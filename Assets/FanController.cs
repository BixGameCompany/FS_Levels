using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FanController : MonoBehaviour
{
    public float fanSpinSpeed = 5f;

    private void Update() {
        transform.Rotate(Vector3.forward * fanSpinSpeed *Time.deltaTime);
    }
}
