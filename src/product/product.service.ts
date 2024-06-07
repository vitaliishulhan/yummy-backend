import { Injectable, Inject } from '@nestjs/common';
import { DATA_SOURCE } from '../consts';
import { DataSource } from 'typeorm';
import { IGetPageResponse, IProductWithCategories } from './product.types';

@Injectable()
export class ProductService {
  constructor(@Inject(DATA_SOURCE) private readonly dataSource: DataSource) {}

  async getPage(page: number, pageSize: number): Promise<IGetPageResponse> {
    const products = await this.dataSource.query<IProductWithCategories[]>(`
      SELECT
        p.id as id, 
        p.name as name,
        p.price as price,
        json_agg(
          json_build_object(
            'id', c.id,
            'name', c.name
          )
        ) as categories
      FROM products p
      LEFT JOIN product_category pc ON p.id = pc.product_id
      LEFT JOIN categories c ON c.id = pc.category_id
      GROUP BY p.id, p.name, p.price
      ORDER BY p.id ASC
      OFFSET ${page * pageSize}
      LIMIT ${pageSize};
    `);

    // TODO should be optimized
    // TODO calculates every request
    const totalCount = +(
      await this.dataSource.query<{ count: number }[]>(`
      SELECT COUNT(*) as count
      FROM products;
    `)
    )[0].count;

    const isNext = !!(
      await this.dataSource.query<unknown[]>(`
      SELECT id
      FROM products
      OFFSET ${(page + 1) * pageSize}
      LIMIT 1
    `)
    ).length;

    return {
      products,
      metadata: {
        page,
        pageSize,
        pagesCount: Math.ceil(totalCount / pageSize),
        totalCount,
        isNext,
      },
    };
  }
}
