defmodule RadiusProxy do 
  def main(args) do
    RadiusDict.init_ets
    RadiusDict.load("dict/dictionary")
    #{:ok,sk} = Radius.listen 1812
    #p = Radius.recv sk
    #IO.puts inspect p
  end
end

