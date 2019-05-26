module Data.Matrix.Transform(
  rotateXM4
  ,rotateXM3
  ,rotateYM4
  ,rotateZM4
  ,(|>>),trans
  ,class VectorTransform
) where

import Prelude

import Data.Array (foldl, zipWith)
import Data.Matrix (class MatrixOps, class MatrixOrder, M3(..), M4(..), Matrix, getOrder, mat3, mat4, rows)
import Data.Vector (class VectorDim, Vector(..), getDim, V3(..), V4(..))
import Math (cos, pi, sin)

radians :: Number -> Number
radians a = a * pi / 180.0


{-
       y
       |
       |_____ x
      /
     /
    z
-}

rotateXM4 :: Number -> Matrix M4
rotateXM4 a = let s = sin( radians a) in
              let c = cos(radians a) in mat4 
                1.0  0.0 0.0  0.0
                0.0  c   (-s) 0.0
                0.0  s   c    0.0
                0.0  0.0 0.0  1.0

rotateXM3 :: Number -> Matrix M3
rotateXM3 a = let s = sin( radians a) in
              let c = cos(radians a) in mat3
                1.0  0.0 0.0  
                0.0  c   (-s) 
                0.0  s   c    


rotateYM4 :: Number -> Matrix M4
rotateYM4 a = let s = sin (radians a) in
              let c = cos (radians a) in mat4
                c    0.0  (s)  0.0
                0.0  1.0  0.0  0.0
                (-s) 0.0  c    0.0  
                0.0  0.0  0.0  1.0

rotateYM3 :: Number -> Matrix M3
rotateYM3 a = let s = sin (radians a) in
              let c = cos (radians a) in mat3
                c   0.0  (-c) 
                0.0 1.0  0.0  
                s   0.0  s     

rotateZM3 :: Number -> Matrix M3
rotateZM3 a = let s = sin $ radians a in
              let c = cos $ radians a in mat3
                c     (-s)  0.0
                s     c     0.0
                0.0   0.0   1.0

rotateZM4 :: Number -> Matrix M4
rotateZM4 a = let s = sin $ radians a in
              let c = cos $ radians a in mat4
                c     (-s)  0.0 0.0
                s     c     0.0 0.0
                0.0   0.0   1.0 0.0
                0.0   0.0   0.0 1.0



class VectorTransform o m where
  trans:: Matrix m -> Vector o ->  Vector o

infixr 6 trans as |>>

ftrans :: forall o m. (MatrixOrder m) => (VectorDim o) =>
  (MatrixOps m) =>
  o -> m -> Matrix m -> Vector o -> Vector o
ftrans o m mat v@(Vector arr d) = if getOrder m == getDim (o) then
    let rs = rows mat in
      (Vector (map (\r -> foldl (\r n->r+n) 0.0 $ zipWith (*) r arr) rs) d)
  else v

instance v3Transform :: VectorTransform V3 M3 where
  trans = ftrans V3 M3

instance v4Transform :: VectorTransform V4 M4 where
  trans = ftrans V4 M4
