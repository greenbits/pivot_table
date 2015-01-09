require 'bundler/gem_tasks'
Bundler::GemHelper.install_tasks

desc "Run all specs"
task :default do
  exec 'rspec spec'
end

class Bundler::GemHelper
  def rubygem_push(path)
    sh("fury push --as=greenbits '#{path}'")
    Bundler.ui.confirm "Pushed #{name} #{version} to gemfury.com"
  end
end
