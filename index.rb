file = File.read('dictionary.txt').split

secret = file[rand(0...file.length)]
puts secret