import { DataSource } from 'typeorm';

export const databaseProvider = {
  provide: 'DATA_SOURCE',
  useFactory: async () => {
    const dataSource = new DataSource({
      type: 'postgres',
      host: 'localhost',
      port: 5432,
      username: 'yummy',
      password: 'admin',
      database: 'commerce',
      entities: [__dirname + '/../**/*.entity{.ts,.js}'],
    });

    return dataSource.initialize();
  },
};
