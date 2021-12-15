using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CoveyorBelt : MonoBehaviour
{
    public bool animationEnabled;
    public bool PhysicsEnabled;
    public float Speed = 4.5f;
    float ScrollY = 1f;

    void Update()
    {
        ScrollY = Speed / -4.4f;
        if(animationEnabled){
            float OffsetY = Time.time * ScrollY;
        GetComponent<Renderer>().material.mainTextureOffset = new Vector2(0, OffsetY);
        }
    }
    Rigidbody rb;
    void Start()
    {
        rb = GetComponent<Rigidbody>();
    }
    void FixedUpdate()
    {
        if(PhysicsEnabled){
        Vector3 pos = rb.position;
        rb.position += transform.up * -Speed * Time.fixedDeltaTime;
        rb.MovePosition(pos);
        }
        
    }
}
