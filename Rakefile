task default: :lint

task :lint do
  FileList["charts/*"].each do |chart|
    sh "helm lint #{chart}"
  end
end
