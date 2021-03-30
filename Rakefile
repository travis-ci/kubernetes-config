require 'open3'
require 'yaml'

task default: %i[lint validate package]

CHARTS = FileList["charts/*"].resolve

task :lint do
  sh "helm repo rm stable"
  sh "helm repo add stable https://charts.helm.sh/stable --force-update"
  CHARTS.each do |chart|    
    sh "helm dependency update #{chart}"
  end
end

task :lint do
  CHARTS.each do |chart|
    sh "helm lint #{chart}"
  end
end

task :package do
  mkdir_p "dist"
  Dir.chdir "dist" do
    CHARTS.each do |chart|
      sh "helm package -u ../#{chart}"
    end
    sh "helm repo index . --url https://charts.helm.sh/stable"
  end
end

RELEASES = FileList["releases/**/*.yaml"]

task :validate do
  RELEASES.each do |release|
    next if validate_release(release) == 'skip'
  end
end

def validate_release(release)
  r = YAML.safe_load(File.read(release))
  if r['kind'] != "HelmRelease" || r['spec']['chart']['git'] != "git@github.com:travis-ci/kubernetes-config.git"
    puts "==> Skipping \`helm template\` for file #{release}"
    return 'skip'
  end 

  namespace = r['metadata']['namespace']
  release_name = r['spec']['releaseName']
  chart_path = r['spec']['chart']['path']
  values = r['spec']['values']

  Open3.popen2e('helm', 'template', chart_path, '-n', release_name, '--namespace', namespace, '-f', '-') do |stdin, output, wait|
    stdin.write(YAML.dump(values))
    stdin.close

    out = output.read

    status = wait.value
    if status.success?
      puts "Release #{release} rendered successfully."
    else
      puts "Release #{release} failed to render. Output from helm:"
      puts out
      exit 1
    end
  end
end
