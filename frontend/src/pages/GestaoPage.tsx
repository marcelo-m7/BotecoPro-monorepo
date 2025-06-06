import React, { useEffect, useState } from 'react';
import { DataService } from '../services/DataService';
import type { Funcionario } from '../types';

export default function GestaoPage() {
  const [funcionarios, setFuncionarios] = useState<Funcionario[]>([]);

  useEffect(() => {
    DataService.getFuncionarios().then(setFuncionarios);
  }, []);

  return (
    <div>
      <h1>Gestão - Funcionários</h1>
      <table>
        <thead>
          <tr>
            <th>Nome</th>
            <th>Cargo</th>
            <th>Admissão</th>
          </tr>
        </thead>
        <tbody>
          {funcionarios.map(f => (
            <tr key={f.funcionario_id}>
              <td>{f.nome}</td>
              <td>{f.cargo}</td>
              <td>{new Date(f.data_admissao).toLocaleDateString()}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
