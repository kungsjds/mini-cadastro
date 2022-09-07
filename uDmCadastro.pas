unit uDmCadastro;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, Datasnap.DBClient, Datasnap.Provider,
  model.entity.produtos;

type
  TdmCadastro = class(TDataModule)
    FDConnCadastro: TFDConnection;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    fdqCreateTables: TFDQuery;
    fdqInsertTables: TFDQuery;
    fdqUpdateTables: TFDQuery;
    cdsProdutos: TClientDataSet;
    dsProdutos: TDataSource;
    fdqSelectTables: TFDQuery;
    dspProdutos: TDataSetProvider;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
    procedure CreateDbFile;
    procedure CreateDbTables;

    procedure SelectProdutos;
    function InsertProduto(pProduto: TProduto): Boolean;
    function UpdateProduto(pProduto: TProduto): Boolean;
    function DeleteProduto: Boolean;
  end;

var
  dmCadastro: TdmCadastro;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDataModule1 }

procedure TdmCadastro.CreateDbFile;
var
  lPath, lPathDB: string;
  lDbFile: TextFile;
  lCreateTables: Boolean;
begin
  lCreateTables := False;
  lPath := ExtractFilePath(ParamStr(0)) + 'DB\';

  if not DirectoryExists(lPath) then
  begin
    if not CreateDir(lPath) then
      ForceDirectories(lPath);
  end;

  lPathDB := lPath + 'cadastro.db';

  if not FileExists(lPathDB) then
  begin
    try
      AssignFile(lDbFile, lPathDB);
      Rewrite(lDbFile);
    finally
      CloseFile(lDbFile);
      lCreateTables := True;
    end;
  end;

  FDConnCadastro.Connected := False;
  FDConnCadastro.Params.Database := lPathDB;
  FDConnCadastro.Connected := True;

  if lCreateTables then
    CreateDbTables;
end;

procedure TdmCadastro.CreateDbTables;
var
  lSql: string;
begin
  lSql := '';

  lSql :=
    ' CREATE TABLE IF NOT EXISTS [produtos] ' +
    '(' +
    '   ID             INTEGER       PRIMARY KEY AUTOINCREMENT NOT NULL, ' +
    '   NOME           VARCHAR (250) NOT NULL, ' +
    '   CODIGO_INTERNO VARCHAR (25), ' +
    '   GTIN           VARCHAR (20), ' +
    '   OBSERVACAO     VARCHAR (250), ' +
    '   VALOR_VENDA    DECIMAL (18, 6), ' +
    '   VALOR_CUSTO    DECIMAL (18, 6), ' +
    '   QTD_ESTOQUE    DECIMAL (18, 6)  ' +
    ')';

  fdqCreateTables.Close;
  fdqCreateTables.SQL.Clear;
  fdqCreateTables.SQL.Add(lSql);
  fdqCreateTables.ExecSQL;
end;

procedure TdmCadastro.DataModuleCreate(Sender: TObject);
begin
  CreateDbFile;
end;

function TdmCadastro.InsertProduto(pProduto: TProduto): Boolean;
var
  lSql: string;
begin
  try
    Result := True;

    lSql := '';

    lSql :=
      ' INSERT INTO produtos ' +
      '(' +
      '   NOME, ' +
      '   CODIGO_INTERNO, ' +
      '   GTIN, ' +
      '   OBSERVACAO, ' +
      '   VALOR_VENDA, ' +
      '   VALOR_CUSTO, ' +
      '   QTD_ESTOQUE ' +
      ')' +
      ' VALUES ' +
      '(' +
        QuotedStr(pProduto.Nome) + ', ' +
        QuotedStr(pProduto.CodigoInterno) + ', ' +
        QuotedStr(pProduto.GTIN) + ', ' +
        QuotedStr(pProduto.Observacao) + ', ' +
        FloatToStr(pProduto.ValorVenda) + ', ' +
        FloatToStr(pProduto.ValorCusto) + ', ' +
        FloatToStr(pProduto.QtdEstoque) +
      ')';

    fdqInsertTables.Close;
    fdqInsertTables.SQL.Clear;
    fdqInsertTables.SQL.Add(lSql);
    fdqInsertTables.ExecSQL;
  except
    Result := False;
  end;
end;

procedure TdmCadastro.SelectProdutos;
var
  lSql: string;
begin
  if not cdsProdutos.IsEmpty then
    cdsProdutos.EmptyDataSet;

  cdsProdutos.DisableControls;
  lSql := '';

  lSql := ' SELECT * FROM produtos ';

  fdqSelectTables.Close;
  fdqSelectTables.SQL.Clear;
  fdqSelectTables.SQL.Add(lSql);

  cdsProdutos.Close;
  cdsProdutos.Open;

  cdsProdutos.EnableControls;
  cdsProdutos.RecordCount;
end;

function TdmCadastro.UpdateProduto(pProduto: TProduto): Boolean;
var
  lSql: string;
begin
  try
    Result := True;

    lSql := '';

    lSql :=
      ' UPDATE produtos ' +
      ' SET ' +
      '   NOME = ' + QuotedStr(pProduto.Nome) + ', ' +
      '   CODIGO_INTERNO = ' + QuotedStr(pProduto.CodigoInterno) + ', ' +
      '   GTIN = ' + QuotedStr(pProduto.GTIN) + ', ' +
      '   OBSERVACAO = ' + QuotedStr(pProduto.Observacao) + ', ' +
      '   VALOR_VENDA = ' + FloatToStr(pProduto.ValorVenda) + ', ' +
      '   VALOR_CUSTO = ' + FloatToStr(pProduto.ValorCusto) + ', ' +
      '   QTD_ESTOQUE = ' + FloatToStr(pProduto.QtdEstoque) +
      ' WHERE ' +
      '   ID = ' + IntToStr(pProduto.Id);

    fdqUpdateTables.Close;
    fdqUpdateTables.SQL.Clear;
    fdqUpdateTables.SQL.Add(lSql);
    fdqUpdateTables.ExecSQL;
  except
    Result := False;
  end;
end;

function TdmCadastro.DeleteProduto: Boolean;
var
  lSql: string;
begin
  try
    Result := True;

    lSql := '';

    lSql :=
      ' DELETE FROM produtos ' +
      ' WHERE ' +
      '   ID = ' + IntToStr(cdsProdutos.FieldByName('ID').AsInteger);

    fdqUpdateTables.Close;
    fdqUpdateTables.SQL.Clear;
    fdqUpdateTables.SQL.Add(lSql);
    fdqUpdateTables.ExecSQL;
  except
    Result := False;
  end;
end;

end.
