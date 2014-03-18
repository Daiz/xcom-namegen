Download =

  file: (data, name) ->

    blob = switch typeof! data
    | \String => new Blob [data], {type: 'text/plain'}
    | _       => data.generate {type: 'blob'}

    link = document.create-element \a
    link.download = name
    link.innerHTML = ''
    link.href = window.URL.create-object-URL blob
    if !window.webkitURL
      link.onclick = (e) !-> document.body.remove-child e.target
      link.style.display = \none
      document.body.append-child link

    link.click!

