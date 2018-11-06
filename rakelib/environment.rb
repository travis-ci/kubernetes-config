require 'rake/clean'
require 'erb'
require 'ostruct'
require 'yaml'

TOP = `git rev-parse --show-toplevel`.chomp
MAKE_SECRET = "#{TOP}/bin/make-secret"

CONFIG = YAML.safe_load(File.read('env.yml'))
ENV_NAME = File.basename(Dir.pwd)

desc "Apply changes to Kubernetes cluster"
task apply: :plan do
  sh "kubectl apply --context=#{ENV_NAME} -f build/secrets/"
  sh "kubectl apply --context=#{ENV_NAME} -R -f build/modules/"
  sh "kubectl apply --context=#{ENV_NAME} -f build/templates/"
end

desc "Create files for resources to be applied"
task plan: :secrets

directory 'build'
CLEAN << 'build'

directory 'build/templates'

local_templates = FileList['templates/*.yaml']
local_templates.each do |template|
  dest = "build/#{template}"
  file dest => ['build/templates', template] do
    cp template, dest
  end

  task plan: dest
end

directory 'build/secrets'

def secret_filename(secret)
  "build/secrets/#{secret['name']}.yaml"
end

CONFIG.fetch('secrets', []).each do |secret|
  file secret_filename(secret) => ['build/secrets'] do
    if secret['file']
      sh make_secret_file_command(secret)
    else
      sh "#{trvs_command secret} | #{make_secret_command secret}"
    end
  end

  desc "Generate Kubernetes secrets from the Travis keychain"
  task secrets: secret_filename(secret)
end

def trvs_command(secret)
  cmd = "trvs generate-config -f yaml "
  cmd += "--pro " if secret['pro']
  cmd += "#{secret['app']} #{secret['env']}"
  cmd
end

def make_secret_command(secret)
  cmd = "#{MAKE_SECRET} -n #{secret['name']} "
  cmd += "-p #{secret['prefix']} " if secret['prefix']
  cmd += "> #{secret_filename(secret)}"
  cmd
end

def make_secret_file_command(secret)
  if secret['pro']
    root = "#{ENV['TRAVIS_KEYCHAIN_DIR']}/travis-pro-keychain"
  else
    root = "#{ENV['TRAVIS_KEYCHAIN_DIR']}/travis-keychain"
  end
  file = "#{root}/#{secret['file']}"
  "#{MAKE_SECRET} -n #{secret['name']} -k #{secret['key']} #{file} > #{secret_filename(secret)}"
end

CONFIG.fetch('modules', []).each do |name, mod|
  build_dir = "build/modules/#{name}"
  directory build_dir

  path = "../modules/#{mod['module']}"

  module_hash = {}
  module_hash.merge!(YAML.safe_load(File.read("#{path}/defaults.yml")))
  module_hash.merge!(mod)
  module_hash['name'] = name

  templates = FileList["#{path}/templates/*.erb"]
  templates.each do |template|
    dest = template.pathmap("#{build_dir}/%n")
    file dest => [build_dir, template] do
      result = ERB.new(File.read(template)).result_with_hash(module_hash)
      File.write(dest, result)
    end

    task "module:#{name}" => dest
  end

  task plan: "module:#{name}"
end
