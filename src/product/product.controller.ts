import { BadRequestException, Controller, Get, Query } from '@nestjs/common';
import { ProductService } from './product.service';
import { IGetPageResponse } from './product.types';

@Controller('products')
export class ProductController {
  constructor(private readonly productService: ProductService) {}

  @Get()
  async getPage(
    @Query() query: { page: number; pageSize: number },
  ): Promise<IGetPageResponse> {
    const page = Number(query.page);
    const pageSize = Number(query.pageSize);

    if (Number.isNaN(page)) {
      throw new BadRequestException('page should be a number');
    }

    if (page < 1) {
      throw new BadRequestException('page should be more or equal to 1');
    }

    if (Number.isNaN(pageSize)) {
      throw new BadRequestException('page size should be a number');
    }

    if (pageSize < 1) {
      throw new BadRequestException('page size should be more or equal to 1');
    }

    return this.productService.getPage(page, pageSize);
  }
}
