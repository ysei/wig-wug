
search_me = ::File.expand_path(
  ::File.join(::File.dirname(__FILE__), 'diggers', '**', '*.rb'))

Dir.glob(search_me).sort.each {|rb| require rb}
