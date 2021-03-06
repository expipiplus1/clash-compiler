module CochleaPlus where

-- CLaSH
import CLaSH.Prelude as C

-- Haskell
import qualified Data.List as L

replaceL xs i x = as L.++ [x] L.++ bs
    where
      (as,b:bs) = L.splitAt i xs

True  % t = 1
False % t = t

-- Haskell
upd hist t = replaceL hist t (hist L.!! t + 1)
-- CLaSH
c_upd hist t = replace t (hist !! t + 1) hist

-- Haskell
upd' hist (True,t)  = upd hist t
upd' hist (False,t) = hist
-- CLaSH
c_upd' hist (True,t)  = c_upd hist t
c_upd' hist (False,t) = hist

-- Haskell
frm (ws,ts,hist) vs = ((ws',ts',hist') , y)

  where
    zcs = L.zipWith (/=) (L.map (>=0) ws) (L.map (>=0) vs)
    ts' = L.zipWith  (%) zcs (L.map (+1) ts)

    -- zts = map snd $ filter fst $ zip zcs ts
    zts = L.zip zcs ts

    hist' = L.foldl upd' hist zts

    ws' = vs
    y   = hist'
-- CLaSH
c_frm (ws,ts,hist) vs = ((ws',ts',hist'),y)
  where
    zcs = zipWith (/=) (map (>=0) ws) (map (>=0) vs)
    ts' = zipWith (%)  zcs (map (+1) ts)

    zts = zip zcs ts

    hist' = foldl c_upd' hist zts

    ws' = vs
    y   = hist'

topEntity :: Signal (Vec 6 Integer) -> Signal (Vec 12 Integer)
topEntity = c_frm `mealy` (c_ws0,c_ts0,c_hist0)

-- Haskell
sim f s [] = []
sim f s (x:xs) = y : sim f s' xs
  where
    (s',y) = f s x
-- CLaSH
c_sim f i = L.take (L.length i) $ simulate f c_vss

c_outp = c_sim topEntity c_vss

-- ===============================================

-- Haskell
vss = [ [  1 :: Int,-1,-1,-1, 1,-1 ]
      , [  1, 1,-1,-1, 1, 1 ]
      , [  1, 1, 1,-1, 1, 1 ]
      , [  1, 1, 1, 1,-1, 1 ]
      , [  1, 1, 1, 1,-1,-1 ]
      , [ -1, 1, 1, 1,-1,-1 ]
      , [ -1,-1, 1, 1, 1,-1 ]
      , [ -1,-1,-1, 1, 1, 1 ]
      , [ -1,-1,-1,-1, 1, 1 ]
      , [ -1,-1,-1,-1,-1, 1 ]
      , [  1,-1,-1,-1,-1,-1 ]
      , [  1, 1,-1,-1,-1,-1 ]
      , [  1, 1, 1,-1, 1,-1 ]
      , [  1, 1, 1, 1, 1, 1 ]
      , [  1, 1, 1, 1, 1, 1 ]
      , [ -1, 1, 1, 1,-1, 1 ]
      , [ -1,-1, 1, 1,-1,-1 ]
      , [ -1,-1,-1, 1,-1,-1 ]
      , [ -1,-1,-1,-1, 1,-1 ]
      , [ -1,-1,-1,-1, 1, 1 ]
      ]

-- CLaSH
c_vss = [ $(v [  1 :: Int,-1,-1,-1, 1,-1 ])
        , $(v [  1 :: Int, 1,-1,-1, 1, 1 ])
        , $(v [  1 :: Int, 1, 1,-1, 1, 1 ])
        , $(v [  1 :: Int, 1, 1, 1,-1, 1 ])
        , $(v [  1 :: Int, 1, 1, 1,-1,-1 ])
        , $(v [ -1 :: Int, 1, 1, 1,-1,-1 ])
        , $(v [ -1 :: Int,-1, 1, 1, 1,-1 ])
        , $(v [ -1 :: Int,-1,-1, 1, 1, 1 ])
        , $(v [ -1 :: Int,-1,-1,-1, 1, 1 ])
        , $(v [ -1 :: Int,-1,-1,-1,-1, 1 ])
        , $(v [  1 :: Int,-1,-1,-1,-1,-1 ])
        , $(v [  1 :: Int, 1,-1,-1,-1,-1 ])
        , $(v [  1 :: Int, 1, 1,-1, 1,-1 ])
        , $(v [  1 :: Int, 1, 1, 1, 1, 1 ])
        , $(v [  1 :: Int, 1, 1, 1, 1, 1 ])
        , $(v [ -1 :: Int, 1, 1, 1,-1, 1 ])
        , $(v [ -1 :: Int,-1, 1, 1,-1,-1 ])
        , $(v [ -1 :: Int,-1,-1, 1,-1,-1 ])
        , $(v [ -1 :: Int,-1,-1,-1, 1,-1 ])
        , $(v [ -1 :: Int,-1,-1,-1, 1, 1 ])
        ]

-- Haskell
ws0 = [0 :: Int,-1,-1,-1,0,-1]
ts0 = [0 :: Int,0,0,0,0,0]
hist0 = [0 :: Int,0,0,0,0,0,0,0,0,0,0,0]

-- CLaSH
c_ws0 = $(v [0 :: Int,-1,-1,-1,0,-1])
c_ts0 = $(v [0 :: Int,0,0,0,0,0])
c_hist0 = $(v [0 :: Int,0,0,0,0,0,0,0,0,0,0,0])
