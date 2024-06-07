import { BadRequestException, Controller, Get, Req } from '@nestjs/common';
import { Request } from 'express';
import { ProductService } from './product.service';
import { IGetPageResponse } from './product.types';

@Controller('products')
export class ProductController {
  constructor(private readonly productService: ProductService) {}

  @Get()
  async getPage(
    @Req() req: Request<unknown, unknown, { page: string; pageSize: string }>,
  ): Promise<IGetPageResponse> {
    const page = Number(req.body.page);
    const pageSize = Number(req.body.pageSize);

    if (Number.isNaN(page)) {
      throw new BadRequestException('page should be a number');
    }

    if (Number.isNaN(pageSize)) {
      throw new BadRequestException('page size should be a number');
    }

    return this.productService.getPage(page, pageSize);
  }
}
