(use rfc.http)
(use rfc.uri)
(use file.util)
(use gauche.process)

(define radar-url "https://radar.weather.gov/ridge/standard/KLVX_loop.gif")
(define radar-gif-path "/tmp/latest_radar.gif")
(define lat 38.3051)
(define lon -85.5742)
(define api-url "https://api.weather.gov/points/38.3051,-85.5742")
(define forecast-url "https://api.weather.gov/gridpoints/LMK/56,80/forecast")

(define (download-weather-radar-gif url filename)
  (let-values (((status headers body)
                (http-get (uri-ref url 'host)
                          (uri-ref url 'path)
                          :secure #t
                          :receiver (http-file-receiver filename))))
    (unless (string=? status "200")
      (error "Failed to download file" url status))
    filename))

(define (play-radar-gif)
  (let* ([mpv-command
          (list "mpv"
                "--loop=inf"
                "--autofit=400x480"
                radar-gif-path)]
         [process (run-process mpv-command)])
    (process-wait process)))
