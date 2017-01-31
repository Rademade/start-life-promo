(() ->
  if /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)
    el = document.querySelector('html')
    el.className = "is-mobile-device"
)()