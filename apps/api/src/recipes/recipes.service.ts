import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma/prisma.service';

@Injectable()
export class RecipesService {
  constructor(private readonly prisma: PrismaService) {}

  list() {
    return this.prisma.recipe.findMany({
      orderBy: { createdAt: 'asc' },
    });
  }

  bySlug(slug: string) {
    return this.prisma.recipe.findUnique({ where: { slug } });
  }
}
