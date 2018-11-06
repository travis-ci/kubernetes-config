require 'rake/clean'
require 'yaml'

TOP = `git rev-parse --show-toplevel`.chomp
MAKE_SECRET = "#{TOP}/bin/make-secret"

CONFIG = YAML.safe_load(File.read('env.yml'))
ENV_NAME = File.basename(Dir.pwd)

desc "Apply changes to Kubernetes cluster"
task apply: :secrets do
  sh "kubectl apply --context=#{ENV_NAME} -f secrets/"
  sh "kubectl apply --context=#{ENV_NAME} -f templates/"
end

CLEAN << 'secrets'

def secret_filename(secret)
  "secrets/#{secret['name']}.yaml"
end

CONFIG.fetch('secrets', []).each do |secret|
  file secret_filename(secret) do
    mkdir_p 'secrets'
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
