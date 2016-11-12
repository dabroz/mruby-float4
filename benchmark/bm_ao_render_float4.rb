# AO render benchmark
# Original program (C) Syoyo Fujita in Javascript (and other languages)
#      https://code.google.com/p/aobench/
# Ruby(yarv2llvm) version by Hideki Miura
# mruby version by Hideki Miura
# optimization for mruby-float4 by Tomasz Dabrowski
#

IMAGE_WIDTH = 256
IMAGE_HEIGHT = 256
NSUBSAMPLES = 2
NAO_SAMPLES = 8

module Rand
  # Use xorshift
  @@x = 123456789
  @@y = 362436069
  @@z = 521288629
  @@w = 88675123
  BNUM = 1 << 29
  BNUMF = BNUM.to_f
  def self.rand
    x = @@x
    t = x ^ ((x & 0xfffff) << 11)
    w = @@w
    @@x, @@y, @@z = @@y, @@z, w
    w = @@w = (w ^ (w >> 19) ^ (t ^ (t >> 8)))
    (w % BNUM) / BNUMF
  end
end

Vec = Vec3


class Sphere
  def initialize(center, radius)
    @center = center
    @radius = radius
  end

  def center; @center; end
  def radius; @radius; end

  def intersect(ray, isect)
    rs = ray.org - @center
    b = rs.dot(ray.dir)
    c = rs.dot(rs) - (@radius * @radius)
    d = b * b - c
    if d > 0.0 then
      t = - b - Math.sqrt(d)

      if t > 0.0 and t < isect.t then
        isect.t = t
        isect.hit = true
        isect.pl = ray.org + ray.dir * t
        n = isect.pl - @center
        isect.n = n.normalize
      end
    end
  end
end

class Plane
  def initialize(p, n)
    @p = p
    @n = n
  end

  def intersect(ray, isect)
    d = -@p.dot(@n)
    v = ray.dir.dot(@n)
    v0 = v
    if v < 0.0 then
      v0 = -v
    end
    if v0 < 1.0e-17 then
      return
    end

    t = -(ray.org.dot(@n) + d) / v

    if t > 0.0 and t < isect.t then
      isect.hit = true
      isect.t = t
      isect.n = @n
      isect.pl = ray.org + ray.dir * t
    end
  end
end

class Ray
  def initialize(org, dir)
    @org = org
    @dir = dir
  end

  def org; @org; end
  def org=(v); @org = v; end
  def dir; @dir; end
  def dir=(v); @dir = v; end
end

class Isect
  def initialize
    @t = 10000000.0
    @hit = false
    @pl = Vec.new(0.0, 0.0, 0.0)
    @n = Vec.new(0.0, 0.0, 0.0)
  end

  def t; @t; end
  def t=(v); @t = v; end
  def hit; @hit; end
  def hit=(v); @hit = v; end
  def pl; @pl; end
  def pl=(v); @pl = v; end
  def n; @n; end
  def n=(v); @n = v; end
end

def otherBasis(basis, n)
  basis[2] = n

  bx, by, bz = 0, 0, 0

  if n.x < 0.6 and n.x > -0.6 then
    bx = 1.0
  elsif n.y < 0.6 and n.y > -0.6 then
    by = 1.0
  elsif n.z < 0.6 and n.z > -0.6 then
    bz = 1.0
  else
    bx = 1.0
  end

  basis[1] = Vec.new(bx, by, bz)

  basis[0] = basis[1].cross(basis[2]).normalize
  basis[1] = basis[2].cross(basis[0]).normalize
end

class Scene
  def initialize
    @spheres = Array.new
    @spheres[0] = Sphere.new(Vec.new(-2.0, 0.0, -3.5), 0.5)
    @spheres[1] = Sphere.new(Vec.new(-0.5, 0.0, -3.0), 0.5)
    @spheres[2] = Sphere.new(Vec.new(1.0, 0.0, -2.2), 0.5)
    @plane = Plane.new(Vec.new(0.0, -0.5, 0.0), Vec.new(0.0, 1.0, 0.0))
  end

  def ambient_occlusion(isect)
    basis = Array.new(3)
    otherBasis(basis, isect.n)
    transBasis = Array.new(3)
    transBasis[0] = Vec.new(basis[0].x, basis[1].x, basis[2].x)
    transBasis[1] = Vec.new(basis[0].y, basis[1].y, basis[2].y)
    transBasis[2] = Vec.new(basis[0].z, basis[1].z, basis[2].z)

    ntheta    = NAO_SAMPLES
    nphi      = NAO_SAMPLES
    eps       = 0.0001
    occlusion = 0.0

    p0 = isect.pl + isect.n * eps

    nphi.times do |j|
      ntheta.times do |i|
        r = Rand::rand
        rmod = Math.sqrt(1.0 - r)
        phi = 2.0 * 3.14159265 * Rand::rand
        x = Math.cos(phi) * rmod
        y = Math.sin(phi) * rmod
        z = Math.sqrt(r)

        xyz = Vec.new(x, y, z)

        rx = xyz.dot(transBasis[0])
        ry = xyz.dot(transBasis[1])
        rz = xyz.dot(transBasis[2])

        raydir = Vec.new(rx, ry, rz)
        ray = Ray.new(p0, raydir)

        occisect = Isect.new
        @spheres[0].intersect(ray, occisect)
        @spheres[1].intersect(ray, occisect)
        @spheres[2].intersect(ray, occisect)
        @plane.intersect(ray, occisect)
        if occisect.hit
          occlusion = occlusion + 1.0
        end
      end
    end

    occlusion = (ntheta.to_f * nphi.to_f - occlusion) / (ntheta.to_f * nphi.to_f)
    Vec.new(occlusion, occlusion, occlusion)
  end

  def render(w, h, nsubsamples)
    nsf = nsubsamples.to_f
    rnsf = 1.0 / nsf
    mod = 255.0 * rnsf * rnsf
    wf = w.to_f
    hf = h.to_f
    wfmod = 1.0 / (wf * 0.5)
    hfmod = 1.0 / (hf * 0.5)
    h.times do |y|
      w.times do |x|
        rad = Vec.new(0.0, 0.0, 0.0)
        xf = x.to_f
        yf = y.to_f

        # Subsmpling
        nsubsamples.times do |v|
          nsubsamples.times do |u|
            uf = u.to_f
            vf = v.to_f
            px = (xf + (uf * rnsf) - (wf * 0.5)) * wfmod
            py = -(yf + (vf * rnsf) - (hf * 0.5)) * hfmod

            eye = Vec.new(px, py, -1.0).normalize

            ray = Ray.new(Vec.new(0.0, 0.0, 0.0), eye)

            isect = Isect.new
            @spheres[0].intersect(ray, isect)
            @spheres[1].intersect(ray, isect)
            @spheres[2].intersect(ray, isect)
            @plane.intersect(ray, isect)
            if isect.hit
              col = ambient_occlusion(isect)
              rad += col
            end
          end
        end

        rgb = (rad * mod).clamp(0, 255).to_ivec
        printf("%c", rgb.x)
        printf("%c", rgb.y)
        printf("%c", rgb.z)
      end
    end
  end
end

# File.open("ao.ppm", "w") do |fp|
printf("P6\n")
printf("%d %d\n", IMAGE_WIDTH, IMAGE_HEIGHT)
printf("255\n", IMAGE_WIDTH, IMAGE_HEIGHT)
Scene.new.render(IMAGE_WIDTH, IMAGE_HEIGHT, NSUBSAMPLES)
#  Scene.new.render(256, 256, 2)
# end
