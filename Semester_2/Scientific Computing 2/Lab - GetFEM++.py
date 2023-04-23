import getfem as gf
import numpy as np

m = gf.Mesh('triangles grid', np.arange(0,1.1,0.1), np.arange(0,1.1,0.1))
mf = gf.MeshFem(m,1)
mf.set_fem(gf.Fem('FEM_PK(2,2)'))
print gf.Fem('FEM_PK(2,2)').poly_str()

mim = gf.MeshIm(m, gf.Integ('IM_TRIANGLE(4)'))

border = m.outer_faces()
m.set_region(42, border)


md = gf.Model('real')
md.add_fem_variable('u', mf)

md.add_Laplacian_brick(mim, 'u');

g = mf.eval('x*(x-1) - y*(y-1)')
md.add_initialized_fem_data('DirichletData', mf, g)
md.add_Dirichlet_condition_with_multipliers(mim, 'u', mf, 42, 'DirichletData')

f = mf.eval('0')
md.add_initialized_fem_data('VolumicData', mf, f)
md.add_source_term_brick(mim, 'u', 'VolumicData')

md.solve()
u = md.variable('u')
mf.export_to_pos('u.pos',u,'Computed solution')
