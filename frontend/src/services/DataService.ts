import type { Mesa, Pedido, Prato, Ingrediente, Funcionario } from '../types';

const LOCAL_STORAGE_KEY = 'botecoProData';
let useApi = false;
let apiBaseUrl = '';

function loadMocks<T>(fileName: string): Promise<T[]> {
  return fetch(`/src/mocks/${fileName}`).then(res => res.json());
}

export async function getMesas(): Promise<Mesa[]> {
  if (!useApi) {
    return loadMocks<Mesa>('mesas.json');
  }
  const res = await fetch(`${apiBaseUrl}/mesas_disponiveis`);
  return await res.json();
}

export async function getPedidos(): Promise<Pedido[]> {
  if (!useApi) {
    return loadMocks<Pedido>('pedidos.json');
  }
  const res = await fetch(`${apiBaseUrl}/pedidos/em_andamento`);
  return await res.json();
}

export async function getPratos(): Promise<Prato[]> {
  if (!useApi) {
    return loadMocks<Prato>('pratos.json');
  }
  const res = await fetch(`${apiBaseUrl}/pratos`);
  return await res.json();
}

export async function getEstoque(): Promise<Ingrediente[]> {
  if (!useApi) {
    return loadMocks<Ingrediente>('estoque.json');
  }
  const res = await fetch(`${apiBaseUrl}/estoque/ingredientes`);
  return await res.json();
}

export async function getFuncionarios(): Promise<Funcionario[]> {
  if (!useApi) {
    return loadMocks<Funcionario>('funcionarios.json');
  }
  const res = await fetch(`${apiBaseUrl}/funcionarios`);
  return await res.json();
}

export function saveLocal<T>(key: string, data: T[]): void {
  localStorage.setItem(`${LOCAL_STORAGE_KEY}-${key}`, JSON.stringify(data));
}

export function loadLocal<T>(key: string): T[] | null {
  const raw = localStorage.getItem(`${LOCAL_STORAGE_KEY}-${key}`);
  return raw ? JSON.parse(raw) : null;
}

export async function syncWithApi(baseUrl: string): Promise<void> {
  useApi = true;
  apiBaseUrl = baseUrl;
  // Stub: could send local changes to API here
}

export const DataService = {
  getMesas,
  getPedidos,
  getPratos,
  getEstoque,
  getFuncionarios,
  saveLocal,
  loadLocal,
  syncWithApi
};
