import { z } from 'zod'

const tileSchema = z.object({
    suit: z.enum(['man', 'pin', 'sou', 'honor']),
    number: z.number().min(1).max(9).optional(),
    honor: z
        .enum(['east', 'south', 'west', 'north', 'white', 'green', 'red'])
        .optional(),
    isRed: z.boolean().optional(),
})

const tileGroupSchema = z.object({
    type: z.enum(['sequence', 'triplet', 'quad', 'pair']),
    tiles: z.array(tileSchema),
    isOpen: z.boolean(),
})

const handSchema = z.object({
    tiles: z.array(tileSchema).min(1).max(14),
    melds: z.array(tileGroupSchema).max(4),
    winningTile: tileSchema,
    isTsumo: z.boolean(),
})

const gameContextSchema = z.object({
    roundWind: z.enum(['east', 'south', 'west', 'north']),
    seatWind: z.enum(['east', 'south', 'west', 'north']),
    dora: z.array(tileSchema),
    uraDora: z.array(tileSchema).optional(),
    honba: z.number().min(0),
    riichi: z.boolean(),
    doubleRiichi: z.boolean().optional(),
    ippatsu: z.boolean().optional(),
    rinshan: z.boolean().optional(),
    chankan: z.boolean().optional(),
    haitei: z.boolean().optional(),
})

export const calculateScoreSchema = z.object({
    hand: handSchema,
    context: gameContextSchema,
})

export type CalculateScoreInput = z.infer<typeof calculateScoreSchema>
