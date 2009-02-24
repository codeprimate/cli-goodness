#!/usr/bin/ruby

def get_project_description
  description = ''
  ok = false
  while (not ok)
    print "Enter Project Description: "
    description = gets.chomp
    puts "Description (ENTER for no change): #{description}"
    print "Is this ok? (y/n/q):"
    ok = gets.chomp
    ok = (ok == 'y')
    return if ok == 'q'
  end
  unless description.empty?
    f = File.open(".git/description", 'w')
    f.puts description
    f.close
  end
end

def copy_git_hooks
  print "\nCopy Hooks? (y/n) "
  if (gets.chomp == 'y')
    puts "Copying git hooks..."
    system 'cp -vf $CLI_GOODNESS/git-goodness/hooks/* .git/hooks/'
    system 'chmod u+x .git/hooks/*'
  end
end


if File.exist?(".git/hooks")
  get_project_description
  copy_git_hooks
else
  puts "Copy of Git hooks failed.  Not a Git repo."
end

