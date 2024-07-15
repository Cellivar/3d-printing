services {
  name = "crowsnest_logitech"
  id   = "crowsnest_logitech"
  port = 8081
  tags = [
    "apps",
    "urlprefix-logitech_crowsnest.squeak.house:80/ redirect=301,https://logitech_crowsnest.squeak.house$path",
    "urlprefix-logitech_crowsnest.squeak.house/",
    "hostname"
  ]

  meta = {
    hostname = "logitech_crowsnest.squeak.house"
  }

  check {
    name     = "alive"
    http     = "http://localhost:8081/"
    interval = "10s"
    timeout  = "2s"
    disable_redirects = true
  }
}

services {
  name = "crowsnest_sunplus"
  id   = "crowsnest_sunplus"
  port = 8082
  tags = [
    "apps",
    "urlprefix-sunplus_crowsnest.squeak.house:80/ redirect=301,https://sunplus_crowsnest.squeak.house$path",
    "urlprefix-sunplus_crowsnest.squeak.house/",
    "hostname"
  ]

  meta = {
    hostname = "sunplus_crowsnest.squeak.house"
  }

  check {
    name     = "alive"
    http     = "http://localhost:8082/"
    interval = "10s"
    timeout  = "2s"
    disable_redirects = true
  }
}

services {
  name = "crowsnest_wansview"
  id   = "crowsnest_wansview"
  port = 8083
  tags = [
    "apps",
    "urlprefix-wansview_crowsnest.squeak.house:80/ redirect=301,https://wansview_crowsnest.squeak.house$path",
    "urlprefix-wansview_crowsnest.squeak.house/",
    "hostname"
  ]

  meta = {
    hostname = "wansview_crowsnest.squeak.house"
  }

  check {
    name     = "alive"
    http     = "http://localhost:8083/"
    interval = "10s"
    timeout  = "2s"
    disable_redirects = true
  }
}
