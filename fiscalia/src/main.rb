require 'docker'


=begin
    "HostConfig": {
         "Binds": ["/tmp:/tmp"],
         "Links": ["redis3:redis"],
         "Memory": 0,
         "MemorySwap": 0,
         "MemoryReservation": 0,
         "KernelMemory": 0,
         "CpuPercent": 80,
         "CpuShares": 512,
         "CpuPeriod": 100000,
         "CpuQuota": 50000,
         "CpusetCpus": "0,1",
         "CpusetMems": "0,1",
         "MaximumIOps": 0,
         "MaximumIOBps": 0,
         "BlkioWeight": 300,
         "BlkioWeightDevice": [{}],
         "BlkioDeviceReadBps": [{}],
         "BlkioDeviceReadIOps": [{}],
         "BlkioDeviceWriteBps": [{}],
         "BlkioDeviceWriteIOps": [{}],
         "MemorySwappiness": 60,
         "OomKillDisable": false,
         "OomScoreAdj": 500,
         "PidsLimit": -1,
         "PortBindings": { "22/tcp": [{ "HostPort": "11022" }] },
         "PublishAllPorts": false,
         "Privileged": false,
         "ReadonlyRootfs": false,
         "Dns": ["8.8.8.8"],
         "DnsOptions": [""],
         "DnsSearch": [""],
         "ExtraHosts": null,
         "VolumesFrom": ["parent", "other:ro"],
         "CapAdd": ["NET_ADMIN"],
         "CapDrop": ["MKNOD"],
         "GroupAdd": ["newgroup"],
         "RestartPolicy": { "Name": "", "MaximumRetryCount": 0 },
         "NetworkMode": "bridge",
         "Devices": [],
         "Ulimits": [{}],
         "LogConfig": { "Type": "json-file", "Config": {} },
         "SecurityOpt": [],
         "StorageOpt": {},
         "CgroupParent": "",
         "VolumeDriver": "",
         "ShmSize": 67108864
      },
      "NetworkingConfig": {
      "EndpointsConfig": {
          "isolated_nw" : {
              "IPAMConfig": {
                  "IPv4Address":"172.20.30.33",
                  "IPv6Address":"2001:db8:abcd::3033",
                  "LinkLocalIPs:["169.254.34.68", "fe80::3468"]
              },
              "Links":["container_1", "container_2"],
              "Aliases":["server_x", "server_y"]
          }
      }
=end

# docker rm -f $(docker ps -a -q)
container = Docker::Container.create('Cmd'=> '/bin/bash','Image' => 'carlochess/fiscalia', 'Tty' => true)
container.start
#container.exec(['wget','–quiet','https://gist.githubusercontent.com/carlochess/ca5d171018d5d1798f3c7affbec6564a/raw/fded5ac1417569575fa47e9bce221f4b5e49433c/main.hs', '-P','/tmp'])
container.exec(['git','clone','https://github.com/ilv/Problems/', '/tmp/borrar'])
ejecutor = Docker::Container.create('Cmd' => ['/bin/bash'], 'Image' => 'haskell:7.8', 'Tty' => true)
ejecutor.start

str = StringIO.new()
str = str.binmode
#container.copy('/tmp') { |chunk| chunks << chunk }
container.archive_out('/tmp') { |chunk| str.puts chunk }
#chunks = chunks.join("\n") << "\n"


=begin
File.open('output.tar', 'wb') do |file|
    container.archive_out('/tmp') do |chunk|
         file.write chunk
    end
end
=end
puts "Enviando imagen"
ejecutor.archive_in_stream('/', overwrite: true) { str.read }


#ejecutor.exec(['ghc','-v0', '-O', '/tmp/main.hs'])
#st = ejecutor.exec(['/tmp/main'], stdin: StringIO.new("2 2\n2 2\n2 2\n"))
#puts st


def descargarImagen
    Docker::Image.search('term' => 'sshd')
    image = Docker::Image.create('fromImage' => 'ubuntu:14.04')
end

def construirImagen(base)
    image = Docker::Image.build("FROM ubuntu MAINTAINER\ncarlochess <carlochess@gmail.com>\nRUN apt-get update && apt-get install -y openssl wget git  && rm -rf /var/lib/apt/lists/*")
    # => Docker::Image { :id => b750fe79269d2ec9a3c593ef05b4332b1d1a02a62b4accb2c21d589ff2f5f2dc, :connection => Docker::Connection { :url => tcp://localhost, :options => {:port=>2375} } }
    image.tag('repo' => 'carlochess/fiscalia', 'tag' => 'latest', force: true)
end

def existeImagen(img)
    Docker::Image.exist?(img)
end

def listarContenedores
    Docker::Container.all(all: true, filters: { label: [ "label_name"  ]  }.to_json)
end


#container.delete(:force => true)
ejecutor.delete(:force => true)
