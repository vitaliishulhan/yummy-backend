import { IProduct } from './product.entity';

export interface IProductWithCategories extends IProduct {
  categories: {
    id: number;
    name: string;
  }[];
}

export interface IGetPageResponse {
  metadata: {
    page: number;
    pageSize: number;
    pagesCount: number;
    totalCount: number;
    isNext: boolean;
  };

  products: IProductWithCategories[];
}
