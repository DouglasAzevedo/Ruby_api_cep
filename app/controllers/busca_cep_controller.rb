class BuscaCepController < ApplicationController
    require 'net/http'
    require 'json'

    def buscar
        @cep = cep_params[:cep]
        url = "https://viacep.com.br/ws/#{@cep}/json/"

        retorno = JSON.parse(NET::HTTP.get(URI(url)))

        if retorno["erro"]
            render json: {erro: "CEP nao existe"}, status: :ok
        else
            estado = Estado.find_or_initialize_by(uf: retorno["uf"])
            estado.save

            cidade = Cidade.find_or_initialize_by(nome: retorno["localidade"],
                        estado_id: estado.id)
            cidade.save

            endereco = Endereco.find_or_initialize_by(cep: retorno["cep"])
            endereco.cidade = cidade
            endereco.logradouro = retorno["logradouro"]
            endereco.bairro = retorno["bairro"]
            endereco.complemento = retorno["complemento"]
            endereco.save

            render json: endereco.to_json, status: :ok
        end
        #endereco = Endereco.new

        render json: {cidade: retorno["localidade"]}, status: :ok

    rescue JSON::ParserError => exception
        render json: {erro: "O Cep é invalido"}, status: :ok
    
    rescue => exception
        render json: {erro: "Ligar no suporte"}, status: :ok
        debugger    
    end

    private

    def cep_params
        params.permit(:cep)
    end
end    