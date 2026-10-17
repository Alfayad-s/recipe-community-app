import { Controller, Get, NotFoundException, Param } from '@nestjs/common';
import { ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { RecipesService } from './recipes.service';

@ApiTags('recipes')
@Controller('recipes')
export class RecipesController {
  constructor(private readonly recipes: RecipesService) {}

  @Get()
  @ApiOkResponse({ description: 'Popular recipes with Cloudinary images' })
  list() {
    return this.recipes.list();
  }

  @Get(':slug')
  async bySlug(@Param('slug') slug: string) {
    const recipe = await this.recipes.bySlug(slug);
    if (!recipe) {
      throw new NotFoundException(`Recipe ${slug} was not found`);
    }
    return recipe;
  }
}
