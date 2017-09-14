_zLevel = zLevel
function zLevel(level)
    local i=level
  --[[  while i > 0 do
        --[[layers[i] = layers[i] or image(WIDTH,HEIGHT)
        i = i - 1 ]]
    --[[end]]
    layers[i] = layers[i] or image(WIDTH,HEIGHT)--]]
    setContext(layers[level])
end