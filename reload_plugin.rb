require 'sketchup.rb'

PATH = "E:/plug in vinh/vinharchi_tool"
paths = [
"E:/plug in vinh",
]


# Un-comment if you want to see any potential loading errors in the Ruby
# Console:
# SKETCHUP_CONSOLE.show

paths.each { |path|
  $LOAD_PATH << path
  Dir.glob("#{path}/*.{rb,rbs,rbe}") { |file|
    Sketchup.require(file)
  }
}
class DirScanner
   def initialize(path)
      @extra_plugin_path = path
      @sem = @extra_plugin_path+"/.sem"
   end
   def doload(checksem=false)
      Dir["#{@extra_plugin_path}/*.rb"].each() { |x|
         if (!checksem) or (File.mtime(x) > File.mtime(@sem))
            touch
            load(x)
            puts "(Re-)loaded #{x}"
         end
      }
      nil
   end
   def touch
      File.new(@sem, "w").close()
   end
   def scan
      doload
      UI::start_timer(1, true) {
         doload(true)
      }
   end
end


if (not file_loaded?("reload_plugin.rb"))
   DirScanner.new(PATH).scan
   file_loaded("reload_plugin.rb")
end

