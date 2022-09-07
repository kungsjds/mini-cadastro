object dmCadastro: TdmCadastro
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 387
  Width = 476
  object FDConnCadastro: TFDConnection
    Params.Strings = (
      'OpenMode=ReadWrite'
      'LockingMode=Normal'
      'DriverID=SQLite')
    Connected = True
    LoginPrompt = False
    Left = 136
    Top = 96
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 136
    Top = 40
  end
  object fdqCreateTables: TFDQuery
    Connection = FDConnCadastro
    Left = 136
    Top = 152
  end
  object fdqInsertTables: TFDQuery
    Connection = FDConnCadastro
    Left = 136
    Top = 208
  end
  object fdqUpdateTables: TFDQuery
    Connection = FDConnCadastro
    Left = 136
    Top = 264
  end
  object cdsProdutos: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    ProviderName = 'dspProdutos'
    StoreDefs = True
    Left = 360
    Top = 136
  end
  object dsProdutos: TDataSource
    DataSet = cdsProdutos
    Left = 360
    Top = 184
  end
  object fdqSelectTables: TFDQuery
    Connection = FDConnCadastro
    Left = 136
    Top = 320
  end
  object dspProdutos: TDataSetProvider
    DataSet = fdqSelectTables
    Left = 356
    Top = 88
  end
end
