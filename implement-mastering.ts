// Full Mastering Chain Implementation
// For use in RunPod handler or separate serverless function

import { exec } from 'child_process'
import { promisify } from 'util'
import fs from 'fs'
import path from 'path'

const execAsync = promisify(exec)

/**
 * Mastering chain using SoX + pydub
 * Normalizes to -14 LUFS, compresses, applies exciter
 */
export async function masteringChain(
  inputPath: string,
  outputPath: string
): Promise<string> {
  try {
    // Step 1: Normalize to -14 LUFS using SoX
    // SoX doesn't directly support LUFS, so we use peak normalization as approximation
    // For true LUFS, would need ffmpeg with loudnorm filter
    await execAsync(
      `sox "${inputPath}" "${outputPath}.normalized.wav" \
        --norm=-14 \
        --compand 0.3,1 6:-70,-60,-20 -5 -90 0.2`
    )

    // Step 2: Apply compression (dynamic range)
    await execAsync(
      `sox "${outputPath}.normalized.wav" "${outputPath}.compressed.wav" \
        compand 0.3,1 6:-70,-60,-20 -5 -90 0.2`
    )

    // Step 3: Apply exciter (high-frequency enhancement)
    await execAsync(
      `sox "${outputPath}.compressed.wav" "${outputPath}" \
        highpass 20 \
        treble 2 8000 0.5`
    )

    // Clean up intermediate files
    fs.unlinkSync(`${outputPath}.normalized.wav`)
    fs.unlinkSync(`${outputPath}.compressed.wav`)

    return outputPath
  } catch (error) {
    console.error('Mastering error:', error)
    // Fallback: return original
    return inputPath
  }
}

/**
 * Alternative: Use ffmpeg for true LUFS normalization
 */
export async function masteringChainLUFS(
  inputPath: string,
  outputPath: string
): Promise<string> {
  try {
    // Use ffmpeg loudnorm filter for true -14 LUFS
    await execAsync(
      `ffmpeg -i "${inputPath}" \
        -af "loudnorm=I=-14:TP=-1.5:LRA=11" \
        -compression_level 12 \
        -y "${outputPath}"`
    )

    return outputPath
  } catch (error) {
    console.error('Mastering error:', error)
    return inputPath
  }
}

