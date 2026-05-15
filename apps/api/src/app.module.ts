import { Module } from '@nestjs/common'
import { ConfigModule } from '@nestjs/config'
import { GraphQLModule } from '@nestjs/graphql'
import { ApolloDriver, ApolloDriverConfig } from '@nestjs/apollo'
import { join } from 'path'

// GraphQL Query Complexity Analyzer
const complexityCalculator = (options: {
  estimators: Record<string, number>
}): number => {
  let complexity = 0
  Object.values(options.estimators).forEach((value) => {
    complexity += value
  })
  return complexity
}

// Placeholder modules - will be filled in during Phase 1
@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env.local',
    }),
    GraphQLModule.forRoot<ApolloDriverConfig>({
      driver: ApolloDriver,
      autoSchemaFile: join(process.cwd(), 'src/schema.gql'),
      playground: process.env.NODE_ENV !== 'production',
      debug: process.env.NODE_ENV !== 'production',
      introspection: process.env.NODE_ENV !== 'production',
      
      // Performance & Security Optimizations
      plugins: [
        {
          requestDidStart: async () => ({
            didResolveOperation: async (requestContext) => {
              // Limit query depth to prevent expensive queries
              const depth = getQueryDepth(requestContext.document)
              if (depth > 10) {
                throw new Error('Query depth exceeds maximum allowed (10)')
              }
            },
          }),
        },
      ],
      
      // Caching configuration
      cache: 'bounded',
      
      // Request timeout (prevent slow queries from hanging)
      persistedQueries: {
        ttl: 3600, // 1 hour
      },
    }),
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}

// Helper function to calculate query depth
function getQueryDepth(document: any, depth = 0): number {
  let maxDepth = depth
  
  if (document.definitions) {
    document.definitions.forEach((def: any) => {
      if (def.selectionSet) {
        const childDepth = getSelectionSetDepth(def.selectionSet, depth + 1)
        maxDepth = Math.max(maxDepth, childDepth)
      }
    })
  }
  
  return maxDepth
}

function getSelectionSetDepth(selectionSet: any, depth: number): number {
  let maxDepth = depth
  
  if (selectionSet.selections) {
    selectionSet.selections.forEach((selection: any) => {
      if (selection.selectionSet) {
        const childDepth = getSelectionSetDepth(selection.selectionSet, depth + 1)
        maxDepth = Math.max(maxDepth, childDepth)
      }
    })
  }
  
  return maxDepth
}
