import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/material.dart';

/// Class building a rotation matrix for rotations about the line through (a, b, c)
/// parallel to [u, v, w] by the angle theta.
///
/// Original implementation in Java by Glenn Murray
/// available online on https://sites.google.com/site/glennmurray/Home/rotation-matrices-and-formulas
class RotationMatrix {
  static const TOLERANCE = 1E-9;
  Float64List? _matrix;

  double? m11;
  double? m12;
  double? m13;
  double? m14;
  double? m21;
  double? m22;
  double? m23;
  double? m24;
  double? m31;
  double? m32;
  double? m33;
  double? m34;

  /// Build a rotation matrix for rotations about the line through (a, b, c)
  /// parallel to [u, v, w] by the angle theta.
  ///
  /// [a] x-coordinate of a point on the line of rotation.
  /// [b] y-coordinate of a point on the line of rotation.
  /// [c] z-coordinate of a point on the line of rotation.
  /// [uUn] x-coordinate of the line's direction vector (unnormalized).
  /// [vUn] y-coordinate of the line's direction vector (unnormalized).
  /// [wUn] z-coordinate of the line's direction vector (unnormalized).
  /// [theta] The angle of rotation, in radians.
  RotationMatrix({
    required double a,
    required double b,
    required double c,
    required double uUn,
    required double vUn,
    required double wUn,
    required double theta,
  }) {
    double l = _longEnough(uUn, vUn, wUn);
    assert(l > 0, 'RotationMatrix: direction vector too short!');

    // In this instance we normalize the direction vector.
    double u = uUn / l;
    double v = vUn / l;
    double w = wUn / l;

    // Set some intermediate values.
    double u2 = u * u;
    double v2 = v * v;
    double w2 = w * w;
    double cosT = math.cos(theta);
    double oneMinusCosT = 1 - cosT;
    double sinT = math.sin(theta);

    // Build the matrix entries element by element.
    m11 = u2 + (v2 + w2) * cosT;
    m12 = u * v * oneMinusCosT - w * sinT;
    m13 = u * w * oneMinusCosT + v * sinT;
    m14 = (a * (v2 + w2) - u * (b * v + c * w)) * oneMinusCosT + (b * w - c * v) * sinT;

    m21 = u * v * oneMinusCosT + w * sinT;
    m22 = v2 + (u2 + w2) * cosT;
    m23 = v * w * oneMinusCosT - u * sinT;
    m24 = (b * (u2 + w2) - v * (a * u + c * w)) * oneMinusCosT + (c * u - a * w) * sinT;

    m31 = u * w * oneMinusCosT - v * sinT;
    m32 = v * w * oneMinusCosT + u * sinT;
    m33 = w2 + (u2 + v2) * cosT;
    m34 = (c * (u2 + v2) - w * (a * u + b * v)) * oneMinusCosT + (a * v - b * u) * sinT;
  }

  /// Multiply this [RotationMatrix] times the point (x, y, z, 1),
  /// representing a point P(x, y, z) in homogeneous coordinates.  The final
  /// coordinate, 1, is assumed.
  ///
  /// [x] The point's x-coordinate.
  /// [y] The point's y-coordinate.
  /// [z] The point's z-coordinate.
  ///
  /// Returns the product, in a [Vector3], representing the
  /// rotated point.
  List<double> timesXYZ(double x, double y, double z) {
    final List<double> p = [0.0, 0.0, 0.0];

    p[0] = m11! * x + m12! * y + m13! * z + m14!;
    p[1] = m21! * x + m22! * y + m23! * z + m24!;
    p[2] = m31! * x + m32! * y + m33! * z + m34!;

    return p;
  }

  /// Compute the rotated point from the formula given in the paper, as opposed
  /// to multiplying this matrix by the given point. Theoretically this should
  /// give the same answer as [timesXYZ]. For repeated
  /// calculations this will be slower than using [timesXYZ]
  /// because, in effect, it repeats the calculations done in the constructor.
  ///
  /// This method is static partly to emphasize that it does not
  /// mutate an instance of [RotationMatrix], even though it uses
  /// the same parameter names as the the constructor.
  ///
  /// [a] x-coordinate of a point on the line of rotation.
  /// [b] y-coordinate of a point on the line of rotation.
  /// [c] z-coordinate of a point on the line of rotation.
  /// [u] x-coordinate of the line's direction vector.  This direction
  ///          vector will be normalized.
  /// [v] y-coordinate of the line's direction vector.
  /// [w] z-coordinate of the line's direction vector.
  /// [x] The point's x-coordinate.
  /// [y] The point's y-coordinate.
  /// [z] The point's z-coordinate.
  /// [theta] The angle of rotation, in radians.
  ///
  /// Returns the product, in a [Vector3], representing the
  /// rotated point.
  static List<double> rotPointFromFormula(double a, double b, double c, double u, double v, double w,
      double x, double y, double z, double theta) {
    // We normalize the direction vector.

    double l;
    if ((l = _longEnough(u, v, w)) < 0) {
      debugPrint('RotationMatrix direction vector too short');
      return [x, y, z];
    }
    // Normalize the direction vector.
    u = u / l; // Note that is not "this.u".
    v = v / l;
    w = w / l;
    // Set some intermediate values.
    double u2 = u * u;
    double v2 = v * v;
    double w2 = w * w;
    double cosT = math.cos(theta);
    double oneMinusCosT = 1 - cosT;
    double sinT = math.sin(theta);

    // Use the formula in the paper.
    final List<double> p = [0.0, 0.0, 0.0];
    p[0] = (a * (v2 + w2) - u * (b * v + c * w - u * x - v * y - w * z)) * oneMinusCosT +
        x * cosT +
        (-c * v + b * w - w * y + v * z) * sinT;

    p[1] = (b * (u2 + w2) - v * (a * u + c * w - u * x - v * y - w * z)) * oneMinusCosT +
        y * cosT +
        (c * u - a * w + w * x - u * z) * sinT;

    p[2] = (c * (u2 + v2) - w * (a * u + b * v - u * x - v * y - w * z)) * oneMinusCosT +
        z * cosT +
        (-b * u + a * v - v * x + u * y) * sinT;

    return p;
  }

  /// Check whether a vector's length is less than [TOLERANCE].
  ///
  /// [u] The vector's x-coordinate.
  /// [v] The vector's y-coordinate.
  /// [w] The vector's z-coordinate.
  ///
  /// Returns length = math.sqrt(u^2 + v^2 + w^2) if it is greater than
  /// [TOLERANCE], or -1 if not.
  static double _longEnough(double u, double v, double w) {
    double l = math.sqrt(u * u + v * v + w * w);
    if (l > TOLERANCE) {
      return l;
    } else {
      return -1;
    }
  }

  /// Get the resulting matrix.
  ///
  /// Returns The matrix as [Matrix4].
  Float64List getMatrix() {
    _matrix ??= Float64List.fromList(
        [m11!, m21!, m31!, 0.0, m12!, m22!, m32!, 0.0, m13!, m23!, m33!, 0.0, m14!, m24!, m34!, 1.0]);
    return _matrix!;
  }
}
