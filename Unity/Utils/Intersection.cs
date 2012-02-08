using UnityEngine;


class Intersection
{

	static public bool PointBoundCheck(Vector3 point, Bounds bound)
	{
		return bound.Contains(point);
	}

	static public bool TriangleBoundCheck(Vector3[] tri, Bounds bound)
	{
		return TriangleBoundCheck(tri, bound.center, bound.size);
	}

	/// <summary>
	/// C# port of http://jgt.akpeters.com/papers/AkenineMoller01/tribox.html
	/// </summary>
	static public bool TriangleBoundCheck(Vector3[] tri, Vector3 center, Vector3 half)
	{
		Vector3 v0 = tri[0],
				v1 = tri[1],
				v2 = tri[2],
				normal, vMin, vMax,
				e0, e1, e2;

		float min, max,
				p0, p1, p2,
				d,
				rad,
				fex, fey, fez;

		v0 -= center;
		v1 -= center;
		v2 -= center;

		e0 = v1 - v2;
		e1 = v2 - v1;
		e2 = v0 - v2;

		fex = Mathf.Abs(e0.x);
		fey = Mathf.Abs(e0.y);
		fez = Mathf.Abs(e0.z);

		// AXISTEST_X01(e0[Z], e0[Y], fez, fey);
		p0 = e0.z * v0.y - e0.y * v0.z;
		p2 = e0.z * v2.y - e0.y * v2.z;
		if (p0 < p2) { min = p0; max = p2; } else { min = p2; max = p0; }
		rad = fez * half.y + fey * half.z;
		if (min > rad || max < -rad)
			return false;
		// AXISTEST_Y02(e0[Z], e0[X], fez, fex);
		p0 = -e0.z * v0.x + e0.x * v0.z;
		p2 = -e0.z * v2.x + e0.x * v2.z;
		if (p0 < p2) { min = p0; max = p2; } else { min = p2; max = p0; }
		rad = fez * half.x + fex * half.z;
		if (min > rad || max < -rad)
			return false;
		// AXISTEST_Z12(e0[Y], e0[X], fey, fex);
		p1 = e0.y * v1.x - e0.x * v1.y;
		p2 = e0.y * v2.x - e0.x * v2.y;
		if (p2 < p1) { min = p2; max = p1; } else { min = p1; max = p2; }
		rad = fey * half.x + fex * half.z;
		if (min > rad || max < -rad)
			return false;

		fex = Mathf.Abs(e1.x);
		fey = Mathf.Abs(e1.y);
		fez = Mathf.Abs(e1.z);

		// AXISTEST_X01(e1[Z], e1[Y], fez, fey);
		p0 = e1.z * v0.y - e1.y * v0.z;
		p2 = e1.z * v2.y - e1.y * v2.z;
		if (p0 < p2) { min = p0; max = p2; } else { min = p2; max = p0; }
		rad = fez * half.y + fey * half.z;
		if (min > rad || max < -rad)
			return false;
		// AXISTEST_Y02(e1[Z], e1[X], fez, fex);
		p0 = -e1.z * v0.x + e1.x * v0.z;
		p2 = -e1.z * v2.x + e1.x * v2.z;
		if (p0 < p2) { min = p0; max = p2; } else { min = p2; max = p0; }
		rad = fez * half.x + fex * half.z;
		if (min > rad || max < -rad)
			return false;
		// AXISTEST_Z0(e1[Y], e1[X], fey, fex);
		p0 = e1.y * v0.x - e1.x * v0.y;
		p1 = e1.y * v1.x - e1.x * v1.y;
		if (p0 < p1) { min = p0; max = p1; } else { min = p1; max = p0; }
		rad = fey * half.x + fex * half.z;
		if (min > rad || max < -rad)
			return false;

		fex = Mathf.Abs(e2.x);
		fey = Mathf.Abs(e2.y);
		fez = Mathf.Abs(e2.z);

		// AXISTEST_X2(e2[Z], e2[Y], fez, fey);
		p0 = e2.z * v0.y - e2.y * v0.z;
		p1 = e2.z * v1.y - e2.y * v1.z;
		if (p0 < p1) { min = p0; max = p1; } else { min = p1; max = p0; }
		rad = fez * half.y + fey * half.z;
		if (min > rad || max < -rad)
			return false;
		// AXISTEST_Y1(e2[Z], e2[X], fez, fex);
		p0 = -e2.z * v0.x + e2.x * v0.z;
		p1 = -e2.z * v1.x + e2.x * v1.z;
		if (p0 < p1) { min = p0; max = p1; } else { min = p1; max = p0; }
		rad = fez * half.x + fex * half.z;
		if (min > rad || max < -rad)
			return false;
		// AXISTEST_Z12(e2[Y], e2[X], fey, fex);
		p1 = e2.y * v1.x - e2.x * v1.y;
		p2 = e2.y * v2.x - e2.x * v2.y;
		if (p2 < p1) { min = p2; max = p1; } else { min = p1; max = p2; }
		rad = fey * half.x + fex * half.z;
		if (min > rad || max < -rad)
			return false;

		// FINDMINMAX(v0[X],v1[X],v2[X],min,max);
		min = max = v0.x;
		if (v1.x < min) min = v1.x;
		if (v1.x > max) max = v1.x;
		if (v2.x < min) min = v2.x;
		if (v2.x > max) max = v2.x;
		if (min > half.x || max < -half.x)
			return false;

		// FINDMINMAX(v0[Y],v1[Y],v2[Y],min,max);
		min = max = v0.y;
		if (v1.y < min) min = v1.y;
		if (v1.y > max) max = v1.y;
		if (v2.y < min) min = v2.y;
		if (v2.y > max) max = v2.y;
		if (min > half.y || max < -half.y)
			return false;

		// FINDMINMAX(v0[Z],v1[Z],v2[Z],min,max);
		min = max = v0.z;
		if (v1.z < min) min = v1.z;
		if (v1.z > max) max = v1.z;
		if (v2.z < min) min = v2.z;
		if (v2.z > max) max = v2.z;
		if (min > half.z || max < -half.z)
			return false;

		normal = Vector3.Cross(e0, e1);
		d = -Vector3.Dot(normal, v0);
		/*if (!PlaneBoxOverlap(normal, d, half))
			return false;*/
		vMin.x = normal.x > 0.0f ? -half.x : half.x;
		vMin.y = normal.y > 0.0f ? -half.y : half.y;
		vMin.z = normal.z > 0.0f ? -half.z : half.z;
		if (Vector3.Dot(normal, vMin) + d > 0.0f)
			return false;

		vMax.x = normal.x > 0.0f ? half.x : -half.x;
		vMax.y = normal.y > 0.0f ? half.y : -half.y;
		vMax.z = normal.z > 0.0f ? half.z : -half.z;
		if (Vector3.Dot(normal, vMax) + d >= 0.0f)
			return true;

		return true;
	}

}
