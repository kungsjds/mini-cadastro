unit uCadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData,
  cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData,
  cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, Vcl.ComCtrls, Vcl.Mask,
  Vcl.DBCtrls, Vcl.Menus, cxButtons, cxContainer, cxTextEdit, cxCurrencyEdit,
  model.entity.produtos;

type
  TFCadastroProdutos = class(TForm)
    pgcProdutos: TPageControl;
    tsProdutos: TTabSheet;
    tsEditaProdutos: TTabSheet;
    cxGrid1: TcxGrid;
    cxGrid1DBTableViewProdutos: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    pnlAcoes: TPanel;
    btnInserir: TcxButton;
    btnAlterar: TcxButton;
    btnExcluir: TcxButton;
    btnCancelar: TcxButton;
    btnSalvar: TcxButton;
    edtNome: TEdit;
    lblNome: TLabel;
    edtCodInterno: TEdit;
    lblCodigoInterno: TLabel;
    edtGTIN: TEdit;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    mmoObservacao: TMemo;
    edtValorVenda: TcxCurrencyEdit;
    edtValorCusto: TcxCurrencyEdit;
    edtQtdEstoque: TcxCurrencyEdit;
    procedure btnInserirClick(Sender: TObject);
    procedure tsEditaProdutosShow(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure tsProdutosShow(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cxGrid1DBTableViewProdutosCellDblClick(
      Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
  private
    { Private declarations }
    FProduto : TProduto;
    FStatusTela: string;

    procedure LimparCampos;
    procedure GridParaEdits;
    procedure CarregarProdutos;
    procedure ShowHidenButtons(lEditando: Boolean);
    procedure DoSalvar;
  public
    { Public declarations }
  end;

var
  FCadastroProdutos: TFCadastroProdutos;

implementation

uses
  uDmCadastro;

{$R *.dfm}

procedure TFCadastroProdutos.btnAlterarClick(Sender: TObject);
begin
  FStatusTela := 'editando';
  pgcProdutos.ActivePage := tsEditaProdutos;
end;

procedure TFCadastroProdutos.btnCancelarClick(Sender: TObject);
begin
  pgcProdutos.ActivePage := tsProdutos;
  LimparCampos;
end;

procedure TFCadastroProdutos.btnExcluirClick(Sender: TObject);
begin
  try
    if not dmCadastro.DeleteProduto then
      Application.MessageBox('Não foi possível excluir o produto.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
  finally
    CarregarProdutos;
  end;
end;

procedure TFCadastroProdutos.btnInserirClick(Sender: TObject);
begin
  FStatusTela := 'inserindo';
  pgcProdutos.ActivePage := tsEditaProdutos;
end;

procedure TFCadastroProdutos.btnSalvarClick(Sender: TObject);
begin
  DoSalvar;
end;

procedure TFCadastroProdutos.LimparCampos;
begin
  edtNome.Text             := '';
  edtCodInterno.Text       := '';
  edtGTIN.Text             := '';
  mmoObservacao.Lines.Text := '';
  edtValorVenda.Text       := '';
  edtValorCusto.Text       := '';
  edtQtdEstoque.Text       := '';
end;

procedure TFCadastroProdutos.GridParaEdits;
begin
  edtNome.Text             := dmCadastro.cdsProdutos.FieldByName('NOME').AsString;
  edtCodInterno.Text       := dmCadastro.cdsProdutos.FieldByName('CODIGO_INTERNO').AsString;
  edtGTIN.Text             := dmCadastro.cdsProdutos.FieldByName('GTIN').AsString;
  mmoObservacao.Lines.Text := dmCadastro.cdsProdutos.FieldByName('OBSERVACAO').AsString;
  edtValorVenda.Value      := dmCadastro.cdsProdutos.FieldByName('VALOR_VENDA').AsFloat;
  edtValorCusto.Value      := dmCadastro.cdsProdutos.FieldByName('VALOR_CUSTO').AsFloat;
  edtQtdEstoque.Value      := dmCadastro.cdsProdutos.FieldByName('QTD_ESTOQUE').AsFloat;
end;

procedure TFCadastroProdutos.CarregarProdutos;
begin
  dmCadastro.SelectProdutos;
  cxGrid1DBTableViewProdutos.ClearItems;
  cxGrid1DBTableViewProdutos.DataController.CreateAllItems(False);

  cxGrid1DBTableViewProdutos.Columns[0].Caption := 'Id';
  cxGrid1DBTableViewProdutos.Columns[1].Caption := 'Nome';
  cxGrid1DBTableViewProdutos.Columns[2].Caption := 'Código';
  cxGrid1DBTableViewProdutos.Columns[3].Caption := 'GTIN';
  cxGrid1DBTableViewProdutos.Columns[4].Caption := 'Observação';
  cxGrid1DBTableViewProdutos.Columns[5].Caption := 'Vlr. Venda';
  cxGrid1DBTableViewProdutos.Columns[6].Caption := 'Vlr. Custo';
  cxGrid1DBTableViewProdutos.Columns[7].Caption := 'Estoque';

  cxGrid1DBTableViewProdutos.Columns[0].Width := 30;
  cxGrid1DBTableViewProdutos.Columns[1].Width := 160;
  cxGrid1DBTableViewProdutos.Columns[2].Width := 90;
  cxGrid1DBTableViewProdutos.Columns[3].Width := 90;
  cxGrid1DBTableViewProdutos.Columns[4].Width := 150;
  cxGrid1DBTableViewProdutos.Columns[5].Width := 85;
  cxGrid1DBTableViewProdutos.Columns[6].Width := 85;
  cxGrid1DBTableViewProdutos.Columns[7].Width := 75;
end;

procedure TFCadastroProdutos.cxGrid1DBTableViewProdutosCellDblClick(
  Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  btnAlterarClick(nil);
end;

procedure TFCadastroProdutos.DoSalvar;
var
  lValue: string;
  lSuccess: Boolean;
begin
  try
    FProduto := TProduto.Create;

    FormatSettings.DecimalSeparator := '.';

    if FStatusTela = 'editando' then
      FProduto.Id := dmCadastro.cdsProdutos.FieldByName('ID').AsInteger
    else
      FProduto.Id := 0;

    FProduto.Nome          := edtNome.Text;
    FProduto.CodigoInterno := edtCodInterno.Text;
    FProduto.GTIN          := edtGTIN.Text;
    FProduto.Observacao    := mmoObservacao.Text;
    FProduto.ValorVenda    := edtValorVenda.Value;
    FProduto.ValorCusto    := edtValorCusto.Value;
    FProduto.QtdEstoque    := edtQtdEstoque.Value;

    if FStatusTela = 'editando' then
      lSuccess := dmCadastro.UpdateProduto(FProduto)
    else
      lSuccess := dmCadastro.InsertProduto(FProduto);

    if not lSuccess then
      Application.MessageBox('Não foi possível salvar o produto.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
  finally
    FreeAndNil(FProduto);
    FormatSettings.DecimalSeparator := ',';
    LimparCampos;
    pgcProdutos.ActivePage := tsProdutos;
  end;
end;

procedure TFCadastroProdutos.FormShow(Sender: TObject);
begin
  pgcProdutos.ActivePage := tsProdutos;
end;

procedure TFCadastroProdutos.ShowHidenButtons(lEditando: Boolean);
begin
  if lEditando then
  begin
    btnInserir.Enabled := False;
    btnAlterar.Enabled := False;
    btnExcluir.Enabled := False;

    btnCancelar.Visible := True;
    btnSalvar.Visible   := True;
  end
  else
  begin
    btnInserir.Enabled := True;
    btnAlterar.Enabled := True;
    btnExcluir.Enabled := True;

    btnCancelar.Visible := False;
    btnSalvar.Visible   := False;
  end;
end;

procedure TFCadastroProdutos.tsEditaProdutosShow(Sender: TObject);
begin
  ShowHidenButtons(True);

  if FStatusTela = 'editando' then
    GridParaEdits;

  if edtNome.CanFocus then
    edtNome.SetFocus;
end;

procedure TFCadastroProdutos.tsProdutosShow(Sender: TObject);
begin
  ShowHidenButtons(False);
  CarregarProdutos;
end;

end.
