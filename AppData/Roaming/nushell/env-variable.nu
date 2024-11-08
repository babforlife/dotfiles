export def --env set-proxy [] {
  let pwd = (input --suppress-output "password:")
  let url = $"http://usr:($pwd)@proxy" 
  load-env { "http_proxy": $url, "https_proxy": $url, "HTTP_proxy": $url, "HTTPS_proxy": $url, "ftp_proxy": $url, "FTP_proxy": $url }
  print "\n\nUsing proxy"
}
