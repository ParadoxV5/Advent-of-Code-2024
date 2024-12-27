target '.' do
  check '*.rb'
  signature '*.rbs'
end

Dir.glob '*/' do|dir|
  dir.chop! # chop off trailing `/`
  target dir do
    check     "#{dir}/**/*.rb"
    ignore    "#{dir}/**/golf*.rb"
    signature '*.rbs'
    signature "#{dir}/**/*.rbs"
  end
end
