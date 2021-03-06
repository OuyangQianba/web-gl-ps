module WebGL(
  WebGLRenderingContext
  ,WebGLProgram
  ,WebGLBuffer
  ,createWebGL
  ,createProgram
  ,L
  ,R
  ,VertexShader
  ,FragmentShader
  ,useProgram
  ,clearColor
  ,createBuffer
  ,bufferData
  ,BufferType
  ,bt_array_buffer
  ,bt_element_array_buffer
  ,usage_dynamic_draw
  ,usage_static_draw
  ,usage_stream_draw
  ,Usage(..)
  ,getAttribLocation
  ,Position
  ,vertexAttribPointer
  ,ValueType
  ,Dimension
  ,one,two,three,four
  ,vt_byte,vt_float,vt_short,vt_ubyte,vt_ushort
  ,mask_color_buffer_bit,mask_depth_buffer_bit,mask_stencil_buffer_bit
  ,Mask
  ,DrawMode
  ,dm_line_loop,dm_line_strip,dm_lines,dm_points,dm_triangle_fan,dm_triangle_strip,dm_triangles
  ,drawArrays
  ,DE_ByteType
  ,unsigned_byte 
  ,unsigned_short
  ,unsigned_int  
  ,drawElements
  ,enableVertexAttribArray
  ,BufferData
  ,bufferDataUInt8
  ,bufferDataUInt32
  ,bindBuffer
  ,ClearMask
  ,clear_color_buffer_bit
  ,clear_depth_buffer_bit
  ,clear_stencil_buffer_bit
  ,clear
  ,class MaskBit
  ,or,(.|.)
  ,enable
  ,enable_depth_test
  ,EnableMask
  ,getUniformLocation
  ,WebGLUniformLocation
  ,uniform1f
  ,uniform1fv
  ,uniform2f
  ,uniform2fv
  ,uniform3f
  ,uniform3fv
  ,uniform4f
  ,uniform4fv
  ,uniform1iv
  ,uniform2i 
  ,uniform2iv
  ,uniform3i 
  ,uniform3iv
  ,uniform4i 
  ,uniform4iv
  ,uniformMat4f
) where

import Data.Either (Either(..))
import Data.Matrix (M4, Matrix, flattenM)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Prelude (class Eq, Unit)
import Web.HTML.HTMLCanvasElement (HTMLCanvasElement)


class MaskBit a where
  or:: a -> a -> a
infixl 4 or as .|.


foreign import data WebGLRenderingContext :: Type
foreign import data WebGLProgram :: Type
foreign import data WebGLBuffer :: Type

type VertexShader = String
type FragmentShader = String

type L =  String  -> Either String WebGLProgram
type R =  WebGLProgram  -> Either String WebGLProgram

foreign import createWebGL :: HTMLCanvasElement -> Effect WebGLRenderingContext

foreign import createProgramImp ::
  L-> R ->
  WebGLRenderingContext -> VertexShader -> FragmentShader
  -> Effect(Either String WebGLProgram )

createProgram :: WebGLRenderingContext -> VertexShader -> FragmentShader -> Effect( Either String WebGLProgram)
createProgram = createProgramImp Left Right

foreign import clearColor:: Number -> Number -> Number -> Number ->WebGLRenderingContext -> Effect Unit

foreign import useProgram ::
  WebGLRenderingContext -> WebGLProgram -> Effect Unit

foreign import createBufferImpl ::
  L -> R -> WebGLRenderingContext -> Effect (Either String WebGLBuffer)

createBuffer :: WebGLRenderingContext -> Effect (Either String WebGLBuffer )
createBuffer = createBufferImpl Left Right

newtype BufferType = BufferType (Int)

bt_array_buffer:: BufferType
bt_array_buffer = BufferType 34962
bt_element_array_buffer:: BufferType
bt_element_array_buffer = BufferType 34963

newtype Usage = Usage Int
usage_static_draw :: Usage
usage_static_draw = Usage 35044
usage_dynamic_draw :: Usage
usage_dynamic_draw = Usage 35048
usage_stream_draw :: Usage
usage_stream_draw = Usage 35040


type BufferData a = WebGLRenderingContext -> BufferType -> Array a -> Usage -> Effect Unit

foreign import bufferData :: BufferData Number

foreign import bufferDataUInt32 :: BufferData Int
foreign import bufferDataUInt8 :: BufferData Int
    
foreign import data Position :: Type

foreign import getAttribLocation
  :: WebGLRenderingContext ->
     WebGLProgram ->
     String ->
     Effect (Position)

newtype Dimension = Dimension Int
one:: Dimension
one = Dimension 1
two:: Dimension
two = Dimension 2
three:: Dimension
three = Dimension 3
four:: Dimension
four = Dimension 4

newtype ValueType = ValueType Int
vt_byte:: ValueType
vt_byte = ValueType 5120
vt_short:: ValueType
vt_short = ValueType 5122
vt_ubyte:: ValueType
vt_ubyte = ValueType 5121
vt_ushort:: ValueType
vt_ushort = ValueType 5123
vt_float:: ValueType
vt_float = ValueType 5126


foreign import vertexAttribPointer
  :: WebGLRenderingContext ->
     Position ->
     Dimension ->
     ValueType ->
     Boolean ->
     Int ->
     Int ->
     Effect Unit

foreign import enableVertexAttribArray
  :: WebGLRenderingContext -> Position -> Effect Unit

newtype Mask = Mask Int
mask_color_buffer_bit:: Mask
mask_color_buffer_bit  = Mask 16384
mask_depth_buffer_bit:: Mask
mask_depth_buffer_bit = Mask 256
mask_stencil_buffer_bit:: Mask
mask_stencil_buffer_bit = Mask 1024

instance maskMask :: MaskBit Mask where
  or (Mask a) (Mask b) = Mask (a `orImpl` b)

foreign import clear
  :: WebGLRenderingContext -> Mask -> Effect Unit

newtype DrawMode = DrawMode Int

-- instance drawModeEq :: 
derive instance drawModeEq :: Eq DrawMode

dm_points :: DrawMode
dm_points = DrawMode 0
dm_lines :: DrawMode
dm_lines = DrawMode 1
dm_line_loop :: DrawMode
dm_line_loop = DrawMode 2
dm_line_strip :: DrawMode
dm_line_strip = DrawMode 3
dm_triangles:: DrawMode
dm_triangles = DrawMode 4
dm_triangle_strip:: DrawMode
dm_triangle_strip = DrawMode 5
dm_triangle_fan:: DrawMode
dm_triangle_fan = DrawMode 6

foreign import drawArrays ::
  WebGLRenderingContext -> DrawMode -> Int -> Int -> Effect Unit

newtype DE_ByteType = DE_ByteType Int

unsigned_byte  = DE_ByteType 5121
unsigned_short = DE_ByteType 5123
unsigned_int   = DE_ByteType 5125

foreign import drawElements ::
  WebGLRenderingContext -> DrawMode -> Int -> DE_ByteType -> Int -> Effect Unit 

foreign import bindBuffer
  :: WebGLRenderingContext -> BufferType -> WebGLBuffer -> Effect Unit

newtype ClearMask = ClearMask (Int)
clear_color_buffer_bit :: ClearMask
clear_color_buffer_bit = ClearMask(16384)
clear_depth_buffer_bit :: ClearMask
clear_depth_buffer_bit = ClearMask(256)
clear_stencil_buffer_bit :: ClearMask
clear_stencil_buffer_bit = ClearMask(1024)

foreign import orImpl ::forall a.
  a->a->a

newtype EnableMask = EnableMask (Int)
enable_depth_test :: EnableMask
enable_depth_test = EnableMask 2929
foreign import enable ::
  WebGLRenderingContext -> EnableMask -> Effect Unit


foreign import data WebGLUniformLocation :: Type
foreign import getUniformLocationImpl :: 
  Maybe WebGLUniformLocation -> (WebGLUniformLocation ->Maybe WebGLUniformLocation)->
  WebGLRenderingContext -> WebGLProgram -> String -> Effect( Maybe WebGLUniformLocation)

getUniformLocation::WebGLRenderingContext-> WebGLProgram -> String -> Effect(Maybe WebGLUniformLocation)
getUniformLocation = getUniformLocationImpl Nothing Just

foreign import uniform1f :: WebGLRenderingContext -> WebGLUniformLocation -> Number -> Effect Unit
foreign import uniform1fv :: WebGLRenderingContext -> WebGLUniformLocation ->Array Number -> Effect Unit
foreign import uniform2f :: WebGLRenderingContext -> WebGLUniformLocation -> Number -> Number -> Effect Unit
foreign import uniform2fv :: WebGLRenderingContext -> WebGLUniformLocation ->Array Number -> Effect Unit
foreign import uniform3f :: WebGLRenderingContext -> WebGLUniformLocation -> Number -> Number -> Number -> Effect Unit 
foreign import uniform3fv :: WebGLRenderingContext -> WebGLUniformLocation ->Array Number -> Effect Unit
foreign import uniform4f :: WebGLRenderingContext -> WebGLUniformLocation -> Number -> Number -> Number -> Number -> Effect Unit
foreign import uniform4fv :: WebGLRenderingContext -> WebGLUniformLocation ->Array Number -> Effect Unit


foreign import uniform1i :: WebGLRenderingContext -> WebGLUniformLocation -> Int -> Effect Unit
foreign import uniform1iv :: WebGLRenderingContext -> WebGLUniformLocation ->Array Int -> Effect Unit
foreign import uniform2i :: WebGLRenderingContext -> WebGLUniformLocation -> Int -> Int -> Effect Unit
foreign import uniform2iv :: WebGLRenderingContext -> WebGLUniformLocation ->Array Int -> Effect Unit
foreign import uniform3i :: WebGLRenderingContext -> WebGLUniformLocation -> Int -> Int -> Int -> Effect Unit 
foreign import uniform3iv :: WebGLRenderingContext -> WebGLUniformLocation ->Array Int -> Effect Unit
foreign import uniform4i :: WebGLRenderingContext -> WebGLUniformLocation -> Int -> Int -> Int -> Int -> Effect Unit
foreign import uniform4iv :: WebGLRenderingContext -> WebGLUniformLocation ->Array Int -> Effect Unit

foreign import uniformMat4fImpl 
  :: (Matrix M4 -> (Array Number)) ->  WebGLRenderingContext -> WebGLUniformLocation -> Matrix M4 -> Effect Unit

uniformMat4f :: WebGLRenderingContext -> WebGLUniformLocation -> Matrix M4 -> Effect Unit
uniformMat4f = uniformMat4fImpl flattenM