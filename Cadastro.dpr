program Cadastro;

uses
  Vcl.Forms,
  uCadastro in 'uCadastro.pas' {FCadastroProdutos},
  uDmCadastro in 'uDmCadastro.pas' {dmCadastro: TDataModule},
  model.entity.produtos in 'model.entity.produtos.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmCadastro, dmCadastro);
  Application.CreateForm(TFCadastroProdutos, FCadastroProdutos);
  Application.Run;
end.
