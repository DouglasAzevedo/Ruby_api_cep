class ComunicacaoViacep

    def buscar(cep)
        
        @cep = cep
        url = "https://viacep.com.br/ws/#{@cep}/json/"

        retorno = JSON.parse(Net::HTTP.get(URI(url)))

        if retorno["erro"]
            return {erro: "CEP nao existe"}
        else

            endereco = GravacaoViacep.new(retorno).gravar

            {end: endereco, municipio:endereco.cidade}
        end
            rescue JSON::ParserError => exception
                 {erro: "O Cep é invalido"}  

    end

end
