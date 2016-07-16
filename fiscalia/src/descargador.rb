class Descargador
  def crearContenedorDescarga(imagen) 'carlochess/fiscalia'
    @container = Docker::Container.create('Cmd'=> '/bin/bash','Image' => imagen, 'Tty' => true)
    @container.start
  end

  def eliminarContendorEvaluacion()
    @container.delete(:force => true) if ! @container.nil?
  end

  def descargarGit(urlGit) # 'https://github.com/ilv/Problems/'
    @container.exec(['git','clone',urlGit, '/tmp/borrar'])
  end

  def descargarUrl(url) # 'https://gist.githubusercontent.com/carlochess/ca5d171018d5d1798f3c7affbec6564a/raw/fded5ac1417569575fa47e9bce221f4b5e49433c/main.hs'
    @container.exec(['wget','–quiet',url, '-P','/tmp'])
  end

  def tomarContenido
    str = StringIO.new()
    str = str.binmode
    container.archive_out('/tmp') { |chunk| str.puts chunk }
    return str
  end
end