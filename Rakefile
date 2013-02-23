desc "watch and compile"
task :default do
  pids = [
    spawn("coffee -w -o js -c js"),
    spawn("sass --watch css:css")
  ]
end