function create_fovbox(bounds,r,color)

plot3([0 bounds(1,1)]+r(1),[0 bounds(2,1)]+r(2),[0 bounds(3,1)]+r(3),'color',color);
plot3([0 bounds(1,2)]+r(1),[0 bounds(2,2)]+r(2),[0 bounds(3,2)]+r(3),'color',color);
plot3([0 bounds(1,3)]+r(1),[0 bounds(2,3)]+r(2),[0 bounds(3,3)]+r(3),'color',color);
plot3([0 bounds(1,4)]+r(1),[0 bounds(2,4)]+r(2),[0 bounds(3,4)]+r(3),'color',color);
plot3([bounds(1,1) bounds(1,2)]+r(1),[bounds(2,1) bounds(2,2)]+r(2),[bounds(3,1) bounds(3,2)]+r(3),'color',color);
plot3([bounds(1,2) bounds(1,3)]+r(1),[bounds(2,2) bounds(2,3)]+r(2),[bounds(3,2) bounds(3,3)]+r(3),'color',color);
plot3([bounds(1,3) bounds(1,4)]+r(1),[bounds(2,3) bounds(2,4)]+r(2),[bounds(3,3) bounds(3,4)]+r(3),'color',color);
plot3([bounds(1,4) bounds(1,1)]+r(1),[bounds(2,4) bounds(2,1)]+r(2),[bounds(3,4) bounds(3,1)]+r(3),'color',color);