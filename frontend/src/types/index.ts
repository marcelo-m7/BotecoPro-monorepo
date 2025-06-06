export interface Mesa {
  mesa_id: number;
  numero: number;
  capacidade: number;
  status: 'livre' | 'ocupada' | 'reservada';
}

export interface Pedido {
  pedido_id: number;
  mesa_id: number;
  funcionario_id: number;
  cliente_id: number | null;
  data_pedido: string;
  status: 'pendente' | 'em_preparo' | 'pronto' | 'entregue' | 'finalizado' | 'cancelado';
}

export interface Prato {
  prato_id: number;
  nome: string;
  categoria_id: number;
  descricao?: string;
  tempo_preparo: number;
  preco_base: number;
}

export interface Ingrediente {
  produto_id: number;
  nome_produto: string;
  stock_atual: number;
  stock_minimo: number;
}

export interface Funcionario {
  funcionario_id: number;
  nome: string;
  cargo: string;
  carreira_id: number;
  data_admissao: string;
}
