export interface Item {
  id: string;
  name: string;
  price: number;
  stock: number;
  store: string;
  dateAdded: string;
}

export interface Summary {
  totalItems: number;
  totalCost: number;
  averagePrice: number;
  mostExpensiveItem: Item | null;
}

export interface ItemsQueryParams {
  page?: number;
  pageSize?: number;
  name?: string;
  sortByPrice?: 'asc' | 'desc';
}

export interface AddItemInput {
  name: string;
  price: number;
  stock: number;
  store: string;
}

export interface UpdateItemInput {
  id: string;
  name?: string;
  price?: number;
  stock?: number;
  store?: string;
}