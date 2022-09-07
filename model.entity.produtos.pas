unit model.entity.produtos;

interface

type

  [Tabela('produtos')]
  TProduto = class
    private
      FId: Integer;
      FNome: string;
      FCodigoInterno: string;
      FGTIN: string;
      FObservacao: string;
      FValorVenda: Double;
      FValorCusto: Double;
      FQtdEstoque: Double;
    public

      [Campo('ID'), Pk, AutoInc]
      property Id: Integer read FId write FId;
      [Campo('NOME')]
      property Nome: string read FNome write FNome;
      [Campo('CODIGO_INTERNO')]
      property CodigoInterno: string read FCodigoInterno write FCodigoInterno;
      [Campo('GTIN')]
      property GTIN: string read FGTIN write FGTIN;
      [Campo('OBSERVACAO')]
      property Observacao: string read FObservacao write FObservacao;
      [Campo('VALOR_VENDA'), Format('#.##0,00')]
      property ValorVenda: Double read FValorVenda write FValorVenda;
      [Campo('VALOR_CUSTO'), Format('#.##0,00')]
      property ValorCusto: Double read FValorCusto write FValorCusto;
      [Campo('QTD_ESTOQUE')]
      property QtdEstoque: Double read FQtdEstoque write FQtdEstoque;

  end;

implementation

end.
