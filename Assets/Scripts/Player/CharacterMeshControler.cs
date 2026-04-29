using UnityEngine;

public class CharacterMeshControler : MonoBehaviour
{
    public Transform mesh;
    private Rigidbody2D rb;
    
    void Start()
    {
        rb = GetComponent<Rigidbody2D>();
    }
    
    void Update()
    {
        if (rb.linearVelocityX > 0.1f)
            mesh.rotation = Quaternion.Euler(0f, -90f, 0f);
        else if (rb.linearVelocityX < -0.1f )
            mesh.rotation = Quaternion.Euler(0f, 90f, 0f);
        // else
        //     mesh.rotation = Quaternion.Euler(0f, 0f, 0f);
    }
}
