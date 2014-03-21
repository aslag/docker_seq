n_lim = 88
n = 0

request = function()
  path = "/api/fib/" .. n
  if n == 88 then
    n = 0
  else
    n = n + 1
  end
  return wrk.format("GET", path)
end
