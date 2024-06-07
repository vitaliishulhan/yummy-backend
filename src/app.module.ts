import { Module } from '@nestjs/common';
import { AppService } from './app.service';
import { DatabaseModule } from './database/database.module';
import { ProductModule } from './product/product.module';

@Module({
  imports: [DatabaseModule, ProductModule],
  providers: [AppService],
})
export class AppModule {}
