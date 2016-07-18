class Evaluador
  def enviarContenido(str)
    @ejecutor.archive_in_stream('/', overwrite: true) { str.read }
  end

  def crearContenedorEvaluacion(imagen) # 'haskell:7.8'
    @ejecutor = Docker::Container.create('Cmd' => ['/bin/bash'], 'Image' => imagen, 'Tty' => true)
    @ejecutor.start
  end

  def eliminarContendorEvaluacion()
    @ejecutor.delete(:force => true)
  end

  def compilarContenido(comando) #['ghc','-v0', '-O', '/tmp/main.hs']
    @ejecutor.exec(comando)
  end

  def ejecutarContenido(contEval, comando, entrada) # ['/tmp/main'], "2 2\n2 2\n2 2\n"
    st = @ejecutor.exec(comando, stdin: StringIO.new(entrada)) # { |stream, chunk| puts "#{stream}: #{chunk}" }
    puts st
  end
end