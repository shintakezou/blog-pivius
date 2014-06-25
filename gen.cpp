// g++ -std=c++11 -O3

#include <iostream>
#include <string>
#include <sstream>
#include <vector>
#include <cmath>
#include <random>



inline bool is_inside(double r, 
                      double cx,
                      double cy,
                      double x,
                      double y)
{
    return ((x-cx)*(x-cx) + (y-cy)*(y-cy)) < r*r;
}

const double radius = 100.0;
const size_t num_dots = 800;
const int max_connect = 3;
const double px = 40.0;
const double py = 40.0;
const double hole_radius = 40.0;
const double min_rad = 0.5;
const double max_rad = 4.0;
const double relevance_threshold = 0.1;
const double PI = 3.14159265358979323846;


struct node
{
    double x;
    double y;
    double r;
    double imp;
    node(double _r, double _x, double _y, double _imp) :
        x(_x), y(_y), r(_r), imp(_imp) { }
    std::string rappr() {
        std::ostringstream ss;
        ss << x << " " << y << " " << r << " " << imp;
        return ss.str(); 
    }
};


int main(int argc, char **argv)
{
    bool fill_hole = false;

    std::default_random_engine rd;
    std::uniform_real_distribution<double> pos(0, radius);
    std::uniform_real_distribution<double> ang(0, 2.0*PI);
    std::uniform_real_distribution<double> sz(min_rad, max_rad);
    std::uniform_real_distribution<double> prob(0,1.0);
  
    std::vector<node> node_list;

    if (argc > 1 && std::string(argv[1]) == "fill") {
        fill_hole = true;
    }


    std::cout << "data " << radius << " "
              << px << " "
              << py << " "
              << hole_radius << "\n";

    for (size_t i = 0; i < num_dots; ) {
        double pr = pos(rd);
        double theta = ang(rd);
        double x = pr * cos(theta);
        double y = pr * sin(theta);
        double r = sz(rd);
        double p0 = prob(rd);
        double imp = p0 > relevance_threshold ? 1.0 + 2.0*p0 : 0.0;
        if (!fill_hole && is_inside(hole_radius, px, py, x, y)) {
            imp = 0.0;
            r /= 2.0;
        }
        node_list.push_back(node(r, x, y, imp));
        ++i;
    }

    std::uniform_int_distribution<size_t> connect(0, node_list.size());
    std::poisson_distribution<size_t> numcon(max_connect);

    int node_id = 0;
    for (auto n : node_list) {
        std::cout << "node " << node_id << " " 
                  << n.rappr() << "\n";
        ++node_id;
    }

    node_id = 0;
    for (auto n : node_list) {
        size_t conn_i = numcon(rd);
        for (size_t i = 0; i < conn_i; ++i) {
            size_t ni = connect(rd);
            double conn_strength = n.imp * node_list[ni].imp / 9.0;
            std::cout << "connect " << node_id << " "
                      << ni << " " << conn_strength << "\n"; 
        }
        ++node_id;
    }

    return 0;
}
