let apiBaseUrl = import.meta.env.VITE_API_BASE_URL || '';
const token = import.meta.env.VITE_API_TOKEN || '';

export function setBaseUrl(url: string) {
  apiBaseUrl = url.replace(/\/$/, '');
}

async function request<T>(endpoint: string, options: RequestInit = {}): Promise<T> {
  const res = await fetch(`${apiBaseUrl}${endpoint}`, {
    headers: {
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json',
      ...options.headers
    },
    ...options
  });
  if (!res.ok) {
    throw new Error(`API error ${res.status}`);
  }
  return res.json();
}

export async function get<T>(endpoint: string): Promise<T> {
  return request<T>(endpoint);
}

export const ApiService = { setBaseUrl, get };
